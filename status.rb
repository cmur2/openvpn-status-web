#!/usr/bin/env ruby

require 'erb'

require 'rubygems'
require 'rack'

class Integer
  def as_bytes
    return "1 Byte" if self == 1
    
    label = ["Bytes", "KiB", "MiB", "GiB", "TiB"]
    i = 0
    num = self.to_f
    while num >= 1024 do
      num = num / 1024
      i += 1
    end
    
    "#{format('%.2f', num)} #{label[i]}"
  end
end

class OpenVPNStatusWeb
  def initialize(name, file)
    @name = name
    @file = file
  end
  
  def call(env)
    main_tmpl = read_template(File.join(File.dirname(__FILE__), 'main.html.erb'))
    # variables for template
    name = @name
    client_list, routing_table, global_stats = read_status_log(@file)
    
    html = main_tmpl.result(binding)
    [200, {"Content-Type" => "text/html"}, html]
  end

  def read_template(file)
    text = File.open(file, 'rb') do |f| f.read end
    
    ERB.new(text)
  end
  
  def read_status_log(file)
    text = File.open(file, 'rb') do |f| f.read end

    current_section = :none
    client_list = []
    routing_table = []
    global_stats = []

    text.lines.each do |line|
      (current_section = :cl; next) if line == "OpenVPN CLIENT LIST\n"
      (current_section = :rt; next) if line == "ROUTING TABLE\n"
      (current_section = :gs; next) if line == "GLOBAL STATS\n"
      (current_section = :end; next) if line == "END\n"
  
      case current_section
      when :cl then client_list << line.strip.split(',')
      when :rt then routing_table << line.strip.split(',')
      when :gs then global_stats << line.strip.split(',')
      end
    end

    [client_list[2..-1], routing_table[1..-1], global_stats]
  end
end

if ARGV.length != 4
  puts "Usage: status.rb vpn-name status-log listen-host listen-port"
else
  Rack::Handler::WEBrick.run OpenVPNStatusWeb.new(ARGV[0], ARGV[1]), :Host => ARGV[2], :Port => ARGV[3]
end
