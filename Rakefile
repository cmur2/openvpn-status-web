# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc 'Run experimental solargraph type checker'
task :solargraph do
  sh 'solargraph typecheck'
end

namespace :solargraph do
  desc 'Should be run by developer once to prepare initial solargraph usage (fill caches etc.)'
  task :init do
    sh 'solargraph download-core'
  end
end

namespace :bundle do
  desc 'Check for vulnerabilities with bundler-audit'
  task :audit do
    sh 'bundler-audit check --ignore GHSA-vvfq-8hwr-qm4m'
  end
end

task default: [:rubocop, :spec, 'bundle:audit']

desc 'Run all tasks desired for CI'
task ci: ['solargraph:init', :default]
