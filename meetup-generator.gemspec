require 'pathname'
require 'date'

Gem::Specification.new do |gem|
  gem.name          = 'meetup-generator'
  gem.version       = 1.0
  gem.date          = Date.today.to_s

  gem.summary       = 'Stupid fatuous random string generatpr'
  gem.description   = 'Generates a website advertising a fictional ' \
                      'DevOps meetup, using all the latest buzzwords, ' \
                      'new-shiny, and clichés'
  gem.authors       = ['Robert Fisher']
  gem.email         = 'slackboy@gmail.com'
  gem.homepage      = 'https://github.com/snltd/meetup-generator'
  gem.license       = 'BSD-2-Clause'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(/^spec\//)

  gem.add_runtime_dependency 'sinatra', '>= 2.0.0'
  gem.add_runtime_dependency 'thin', '~> 1.7', '>= 1.7.0'
  gem.add_runtime_dependency 'slim', '~> 3.0', '>= 3.0.0'

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake', '~> 12.3', '>= 12.3.0'
  gem.add_development_dependency 'rubocop',  '~> 0.52', '>= 0.52.0'
  gem.add_development_dependency 'minitest', '~> 5.10', '>= 5.10.0'
  gem.add_development_dependency 'rack-test', '~> 0.8', '>= 0.8.0'

  gem.required_ruby_version = Gem::Requirement.new('>= 2.2.0')
end
