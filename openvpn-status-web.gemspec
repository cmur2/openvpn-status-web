
$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'openvpn-status-web/version'

Gem::Specification.new do |s|
  s.name  = 'openvpn-status-web'
  s.version = OpenVPNStatusWeb::VERSION
  s.summary = 'openvpn-status-web'
  s.description = 'Small Rack (Ruby) application serving OpenVPN status file.'
  s.author = 'Christian Nicolai'
  s.email = 'chrnicolai@gmail.com'
  s.homepage = 'https://github.com/cmur2/dyndnsd'
  s.license = 'Apache-2.0'

  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
  s.executables = ['openvpn-status-web']

  s.required_ruby_version = '>= 2.3'

  s.add_runtime_dependency 'rack', '~> 2.0'
  s.add_runtime_dependency 'metriks'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'
end
