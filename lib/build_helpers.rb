require_relative 'version'

def gem_version
  format('%s.%d', BASE_VERSION, build_number)
end

def build_number
  format('%03d', number = ENV['TRAVIS_BUILD_NUMBER'] || 0)
end
