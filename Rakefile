require 'pathname'
require 'rake/testtask'
require 'rubocop/rake_task'
require_relative 'lib/build_helpers'

ROOT = Pathname(__FILE__).dirname

task default: :test

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

desc 'build gem'
#task :build => :test do
task :build do
  version = gem_version
  puts "building gem version #{gem_version}"
  `gem build #{ROOT + 'meetup-generator.gemspec'}`
end

