#!/usr/bin/env ruby

%w[sinatra/base slim pathname].each { |f| require f }
require_relative '../lib/meetup-generator'

ROOT = Pathname.new(__FILE__).dirname.parent
MG = MeetupGenerator.new

class MeetupGeneratorWebApp < Sinatra::Base
  set :root, ROOT

  get '/api/:item?/?*' do
    content_type :json
    if MG.respond_to?(params[:item]) && params[:item] != 'initialize'
      MG.send(params[:item]).to_json
    else
      [404, 'not found']
    end
  end

  get '*' do
    @talks = MG.talks
    @food = MG.refreshment
    @jobs = 5.times.with_object([]) do |_i, a|
      a.<< [MG.talker, '//', MG.role, '@', MG.company].join(' ')
    end
    slim :default
  end

  run! if __FILE__ == $0
end
