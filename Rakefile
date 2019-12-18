require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'bundler/audit/task'

RSpec::Core::RakeTask.new(:spec)
Bundler::Audit::Task.new

task :default => [:spec, 'bundle:audit']
