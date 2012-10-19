require 'simplecov'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

desc "Run all tests with code coverage"
task :coverage do
  SimpleCov.start('rails')
  Rake::Task["test"].execute
  Rake::Task["spec"].execute
  Rake::Task["cucumber"].execute

  `open coverage/index.html`
end