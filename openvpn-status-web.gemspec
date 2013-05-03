
$:.push File.expand_path("../lib", __FILE__)

require 'openvpn-status-web/version'

Gem::Specification.new do |s|
  s.name  = 'openvpn-status-web'
  s.version = OpenVPNStatusWeb::VERSION
  s.summary = 'openvpn-status-web'
  s.description = 'Small Rack (Ruby) application serving OpenVPN status file.'
  s.author  = 'Christian Nicolai'
  s.email = 'chrnicolai@gmail.com'
  s.license = 'Apache License Version 2.0'
  s.homepage  = 'https://github.com/cmur2/openvpn-status-web'

  s.files = `git ls-files`.split($/)
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.require_paths = ['lib']

  s.executables = ['openvpn-status-web']

  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'metriks'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rack-test'
end
