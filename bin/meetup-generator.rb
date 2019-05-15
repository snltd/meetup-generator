#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra/base'
require 'slim'
require 'pathname'
require_relative '../lib/meetup_generator'

ROOT = Pathname.new(__FILE__).dirname.parent
MG = MeetupGenerator.new

# The Meetup Generator. Works is done in lib/meetup_generator.rb
#
class MeetupGeneratorWebApp < Sinatra::Base
  def api_methods
    %w[talk title talker role company refreshment agenda date location]
  end

  set :root, ROOT

  get '/api/:item?/?*' do
    content_type :json
    return [404, 'not found'] unless api_methods.include?(params[:item])

    MG.send(params[:item]).to_json.chomp
  end

  get '*' do
    @agenda = MG.agenda(5)
    slim :default
  end

  run! if $PROGRAM_NAME == __FILE__
end
