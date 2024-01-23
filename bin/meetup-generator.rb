#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra/base'
require 'slim'
require 'pathname'
require 'rack/tracer'
require 'wavefrontopentracing'
require 'wavefront/client/direct'
require 'wavefront/client/common/application_tags'
require 'wavefrontopentracing/reporting/wavefront'

require_relative '../lib/meetup_generator'

app_tags = Wavefront::ApplicationTags.new('meetup_generator',
                                          'meetup_generator')

ROOT = Pathname.new(__FILE__).dirname.parent
MG   = MeetupGenerator.new

sender = Wavefront::WavefrontProxyClient.new('wavefront',
                                             2878, 40_000, 30_000)

reporter = Reporting::WavefrontSpanReporter.new(client: sender)

tracer = WavefrontOpentracing::Tracer.new(reporter, app_tags)

OpenTracing.global_tracer = tracer

# The Meetup Generator. Works is done in lib/meetup_generator.rb
#
class MeetupGeneratorWebApp < Sinatra::Base
  use Rack::Tracer
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
    s = OpenTracing.start_span('generate')
    @agenda = MG.agenda(5)
    s.finish
    s = OpenTracing.start_span('render')
    ret = slim :default
    s.finish
    ret
  end

  run! if $PROGRAM_NAME == __FILE__
end
