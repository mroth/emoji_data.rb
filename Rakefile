require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc "Run benchmarks"
task :benchmark do
    sh "ruby scripts/benchmark.rb"
end
