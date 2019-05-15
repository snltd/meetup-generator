# frozen_string_literal: true

require_relative 'version'

def gem_version
  format('%<version>s.%<number>s', version: BASE_VERSION,
                                   number: build_number)
end

def build_number
  ENV['TRAVIS_BUILD_NUMBER'] || 0
end
