require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'bundler/audit/task'

RSpec::Core::RakeTask.new(:spec)
Bundler::Audit::Task.new

desc 'Should be run by developer once to prepare initial solargraph usage (fill caches etc.)'
task :'solargraph:init' do
  sh 'solargraph download-core'
end

desc 'Run experimental solargraph type checker'
task :'solargraph:tc' do
  sh 'solargraph typecheck'
end

task :default => [:spec, 'bundle:audit']

task travis: [:default, :'solargraph:tc']
