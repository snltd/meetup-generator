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
  gem.require_paths = %w[lib]

  gem.required_ruby_version = Gem::Requirement.new('>= 3.1.0')
  gem.metadata['rubygems_mfa_required'] = 'true'
end
