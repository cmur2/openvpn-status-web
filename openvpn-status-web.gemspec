# frozen_string_literal: true

require_relative 'lib/openvpn-status-web/version'

Gem::Specification.new do |s|
  s.name = 'openvpn-status-web'
  s.version = OpenVPNStatusWeb::VERSION
  s.summary = 'openvpn-status-web'
  s.description = 'Small Rack (Ruby) application serving OpenVPN status file.'
  s.author = 'Christian Nicolai'

  s.homepage = 'https://github.com/cmur2/openvpn-status-web'
  s.license = 'Apache-2.0'
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'source_code_uri' => s.homepage
  }

  s.files = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(init.d|lib)/})
  end
  s.require_paths = ['lib']
  s.bindir = 'exe'
  s.executables = ['openvpn-status-web']
  s.extra_rdoc_files = Dir['README.md', 'LICENSE']

  s.required_ruby_version = '>= 3.0'

  s.add_runtime_dependency 'metriks'
  s.add_runtime_dependency 'rack', '~> 3.0'
  s.add_runtime_dependency 'rackup', '~> 2'
  s.add_runtime_dependency 'webrick', '>= 1.6.1'

  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'bundler-audit', '~> 0.9.0'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop', '~> 1.60.0'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  s.add_development_dependency 'rubocop-rspec', '~> 2.26.1'
  s.add_development_dependency 'solargraph', '~> 0.50.0'
end
