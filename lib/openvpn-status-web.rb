#!/usr/bin/env ruby

require 'etc'
require 'logger'
require 'ipaddr'
require 'yaml'
require 'rack'
require 'erb'
require 'metriks'
require 'better_errors'

require 'openvpn-status-web/status'
require 'openvpn-status-web/parser/v1'
require 'openvpn-status-web/parser/v2'
require 'openvpn-status-web/parser/v3'
require 'openvpn-status-web/int_patch'
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
    def initialize(vpns)
      @vpns = vpns

      @main_tmpl = read_template(File.join(File.dirname(__FILE__), 'openvpn-status-web/main.html.erb'))
    end

    def call(env)
      return [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]] if env["REQUEST_METHOD"] != "GET"
      return [404, {"Content-Type" => "text/plain"}, ["Not Found"]] if env["PATH_INFO"] != "/"

      # variables for template
      vpns = @vpns
      stati = {}
      @vpns.each do |name,config|
        stati[name] = parse_status_log(config)
      end
      # eval
      html = @main_tmpl.result(binding)

      [200, {"Content-Type" => "text/html"}, [html]]
    end

    def read_template(file)
      text = File.open(file, 'rb') do |f| f.read end
    
      ERB.new(text)
    end
  
    def parse_status_log(vpn)
      text = File.open(vpn['status_file'], 'rb') do |f| f.read end

      case vpn['version']
      when 1
        OpenVPNStatusWeb::Parser::V1.new.parse_status_log(text)
      when 2
        OpenVPNStatusWeb::Parser::V2.new.parse_status_log(text)
      when 3
        OpenVPNStatusWeb::Parser::V3.new.parse_status_log(text)
      else
        raise "No suitable parser for status-version #{vpn['version']}"
      end
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

      # configure rack
      app = Daemon.new(config['vpns'])
      if ENV['RACK_ENV'] == "development"
        app = BetterErrors::Middleware.new(app)
        BetterErrors.application_root = File.expand_path("..", __FILE__)
      end

      Signal.trap('INT') do
        OpenVPNStatusWeb.logger.info "Quitting..."
        Rack::Handler::WEBrick.shutdown
      end
      
      Rack::Handler::WEBrick.run app, :Host => config['host'], :Port => config['port']
    end
  end
end
