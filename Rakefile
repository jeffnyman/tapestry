#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rdoc/task"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

namespace :script do
  desc "Run the Tapestry simple script"
  task :simple do
    system("ruby ./examples/tapestry-simple.rb")
  end

  desc "Run the Tapestry factory script"
  task :factory do
    system("ruby ./examples/tapestry-factory.rb")
  end

  desc "Run the Tapestry data setter script"
  task :data_set do
    system("ruby ./examples/tapestry-data-set.rb")
  end
end

namespace :spec do
  desc 'Clean all generated reports'
  task :clean do
    system('rm -rf spec/reports')
  end

  RSpec::Core::RakeTask.new(all: :clean) do |config|
    options  = %w[--color]
    options += %w[--format documentation]
    options += %w[--format html --out spec/reports/unit-test-report.html]

    config.rspec_opts = options
  end
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.main = 'README.md'
  rdoc.title = "Tapestry #{Tapestry::VERSION}"
  rdoc.rdoc_files.include('README*', 'lib/**/*.rb')
end

task default: ['spec:all', :rubocop]
