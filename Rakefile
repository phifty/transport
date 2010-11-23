require 'rubygems'

gem 'rspec'
require 'rspec'
require 'rspec/core/rake_task'

gem 'reek'
require 'reek/rake/task'

require 'rake/rdoctask'

task :default => :spec

namespace :gem do

  desc "Builds the gem"
  task :build do
    system "gem build *.gemspec && mkdir -p pkg/ && mv *.gem pkg/"
  end

  desc "Builds and installs the gem"
  task :install => :build do
    system "gem install pkg/"
  end

end

Reek::Rake::Task.new do |task|
  task.fail_on_error = true
end

desc "Generate the rdoc"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.add [ "README.rdoc", "lib/**/*.rb" ]
  rdoc.main = "README.rdoc"
  rdoc.title = ""
end

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new do |task|
  task.pattern = "spec/lib/**/*_spec.rb"
end
