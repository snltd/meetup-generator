# frozen_string_literal: true

require 'date'
require_relative 'lib/version'

Gem::Specification.new do |gem|
  gem.name          = 'meetup-generator'
  gem.version       = VERSION
  gem.date          = Date.today.to_s

  gem.summary       = 'Stupid fatuous random string generatpr'
  gem.description   = 'Generates a website advertising a fictional ' \
                      'DevOps meetup, using all the latest buzzwords, ' \
                      'new-shiny, and clichés'
  gem.authors       = ['Robert Fisher']
  gem.email         = 'rob@sysdef.xyz'
  gem.homepage      = 'https://github.com/snltd/meetup-generator'
  gem.license       = 'BSD-2-Clause'

  gem.bindir        = 'bin'
  gem.executables   = ['meetup-generator.rb', 'locate_meetup-generator']
  gem.files         = IO.readlines('package/runtime_files', chomp: true)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = %w[lib]

  gem.add_runtime_dependency 'puma', '>= 3.12.0', '< 5.0'
  gem.add_runtime_dependency 'sinatra', '~>2.0', '>= 2.0.1'
  gem.add_runtime_dependency 'slim', '~> 4.0', '>= 4.0.1'

  gem.add_development_dependency 'bundler', '~> 2.0'
  gem.add_development_dependency 'minitest', '~> 5.11', '>= 5.11.0'
  gem.add_development_dependency 'nokogiri', '~> 1.10'
  gem.add_development_dependency 'rack-test', '~> 1.1'
  gem.add_development_dependency 'rake', '~> 12.3', '>= 12.3.0'
  gem.add_development_dependency 'rubocop', '~> 0.69'
  gem.add_development_dependency 'rubocop-performance', '~> 1.3'

  gem.required_ruby_version = Gem::Requirement.new('>= 2.4.0')
end
