require 'date'
require 'English'

ROOT = Pathname.new(__FILE__).dirname

require_relative 'lib/build_helpers'

Gem::Specification.new do |gem|
  gem.name          = 'meetup-generator'
  gem.version       = gem_version
  gem.date          = Date.today.to_s

  gem.summary       = 'Stupid fatuous random string generatpr'
  gem.description   = 'Generates a website advertising a fictional ' \
                      'DevOps meetup, using all the latest buzzwords, ' \
                      'new-shiny, and clichés'
  gem.authors       = ['Robert Fisher']
  gem.email         = 'slackboy@gmail.com'
  gem.homepage      = 'https://github.com/snltd/meetup-generator'
  gem.license       = 'BSD-2-Clause'

  gem.bindir        = 'bin'
  gem.executables   = ['meetup-generator.rb', 'locate_meetup-generator']
  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = %w(lib)

  gem.add_runtime_dependency 'sinatra', '~>2.0', '>= 2.0.1'
  gem.add_runtime_dependency 'slim', '~> 3.0', '>= 3.0.0'
  gem.add_runtime_dependency 'puma', '~> 3.11', '>= 3.11.0'

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'minitest', '~> 5.11', '>= 5.11.0'
  gem.add_development_dependency 'nokogiri', '~> 1.8', '>= 1.8.0'
  gem.add_development_dependency 'rack-test', '~> 0.8', '>= 0.8.0'
  gem.add_development_dependency 'rake', '~> 12.3', '>= 12.3.0'
  gem.add_development_dependency 'rubocop', '~> 0.52', '>= 0.52.0'

  gem.required_ruby_version = Gem::Requirement.new('>= 2.2.0')
end
