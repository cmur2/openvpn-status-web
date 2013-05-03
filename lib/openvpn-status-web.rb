#!/usr/bin/env ruby

require 'etc'
require 'logger'
require 'ipaddr'
require 'yaml'
require 'rack'
require 'metriks'

require 'openvpn-status-web/parser/v1'
require 'openvpn-status-web/int_patch'
require 'openvpn-status-web/status'
require 'openvpn-status-web/version'

module OpenVPNStatusWeb
  def self.logger
    @logger
  end

  def self.logger=(logger)
    @logger = logger
  end

  class LogFormatter
    def call(lvl, time, progname, msg)
      "[%s] %-5s %s\n" % [Time.now.strftime('%Y-%m-%d %H:%M:%S'), lvl, msg.to_s]
    end
  end

  class Daemon
    def initialize(name, file)
      @name = name
      @file = file
    end

    def call(env)
      main_tmpl = read_template(File.join(File.dirname(__FILE__), 'openvpn-status-web/main.html.erb'))
      # variables for template
      name = @name
      client_list, routing_table, global_stats = read_status_log(@file)
      
      html = main_tmpl.result(binding)
      [200, {"Content-Type" => "text/html"}, [html]]
    end

    def read_template(file)
      text = File.open(file, 'rb') do |f| f.read end
    
      ERB.new(text)
    end
  
    def read_status_log(file)
      text = File.open(file, 'rb') do |f| f.read end

      OpenVPNStatusWeb::Parser::V1.new.parse_status_log(text)
    end

    def self.run!
      if ARGV.length != 1
        puts "Usage: openvpn-status-web config_file"
        exit 1
      end

      config_file = ARGV[0]

      if not File.file?(config_file)
        puts "Config file not found!"
        exit 1
      end
      
      puts "openvpn-status-web version #{OpenVPNStatusWeb::VERSION}"
      puts "Using config file #{config_file}"

      config = YAML::load(File.open(config_file, 'r') { |f| f.read })
      
      if config['logfile']
        OpenVPNStatusWeb.logger = Logger.new(config['logfile'])
      else
        OpenVPNStatusWeb.logger = Logger.new(STDOUT)
      end

      OpenVPNStatusWeb.logger.progname = "openvpn-status-web"
      OpenVPNStatusWeb.logger.formatter = LogFormatter.new

      OpenVPNStatusWeb.logger.info "Starting..."

      app = Daemon.new(config['name'], config['status_file'])

      Signal.trap('INT') do
        OpenVPNStatusWeb.logger.info "Quitting..."
        Rack::Handler::WEBrick.shutdown
      end
      
      Rack::Handler::WEBrick.run app, :Host => config['host'], :Port => config['port']
    end
  end
end
