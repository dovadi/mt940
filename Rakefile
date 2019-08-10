require 'rubygems'
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task default: :test

task :console do
  require 'irb'
  require 'irb/completion'
  require 'mt940'
  ARGV.clear
  IRB.start
end
