# frozen_string_literal: true

require 'pathname'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'bundler/gem_tasks'

ROOT = Pathname(__FILE__).dirname

task default: %i[rubocop test]

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end
