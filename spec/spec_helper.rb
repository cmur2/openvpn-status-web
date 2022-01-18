# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'rack/test'

require 'openvpn-status-web'

def status_v1
  text = File.binread('examples/status.v1')
  OpenVPNStatusWeb::Parser::V1.new.parse_status_log text
end

def status_v2
  text = File.binread('examples/status.v2')
  OpenVPNStatusWeb::Parser::V2.new.parse_status_log text
end

def status_2_5_v2
  text = File.binread('examples/status2_5.v2')
  OpenVPNStatusWeb::Parser::V2.new.parse_status_log text
end

def status_v3
  text = File.binread('examples/status.v3')
  OpenVPNStatusWeb::Parser::V3.new.parse_status_log text
end
