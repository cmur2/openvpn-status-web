
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
    main_tmpl = read_template('main.html.erb')
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

Rack::Handler::Mongrel.run OpenVPNStatusWeb.new('', ''), :Port => 9292
