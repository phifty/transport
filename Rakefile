require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'reek/rake/task'
require 'rdoc/task'

RSpec::Core::RakeTask.new(:spec)
Rake::RDocTask.new(:spec)

task :default => :spec

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end
