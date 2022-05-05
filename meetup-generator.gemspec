# frozen_string_literal: true

require 'date'

# Github actions sets the RELEASE_VERSION environment variable

Gem::Specification.new do |gem|
  gem.name          = 'meetup-generator'
  gem.version       = ENV.fetch('RELEASE_VERSION',
                                "0.0.#{Time.now.strftime('%Y%m%d')}")

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
  gem.files         = File.readlines('package/runtime_files', chomp: true)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = %w[lib]

  gem.add_runtime_dependency 'puma', '~> 5.6'
  gem.add_runtime_dependency 'sinatra', '~>2.2'
  gem.add_runtime_dependency 'slim', '~> 4.1'

  gem.add_development_dependency 'bundler', '~> 2.3'
  gem.add_development_dependency 'minitest', '~> 5.15'
  gem.add_development_dependency 'nokogiri', '~> 1.13'
  gem.add_development_dependency 'rack-test', '~> 1.1'
  gem.add_development_dependency 'rake', '~> 13.0'
  gem.add_development_dependency 'rubocop', '~> 1.9'
  gem.add_development_dependency 'rubocop-minitest', '~> 0.10'
  gem.add_development_dependency 'rubocop-performance', '~> 1.3'
  gem.add_development_dependency 'rubocop-rake', '~> 0.5'

  gem.required_ruby_version = Gem::Requirement.new('>= 2.5.0')
  gem.metadata['rubygems_mfa_required'] = 'true'
end
