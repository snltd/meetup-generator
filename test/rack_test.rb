#!/usr/bin/env ruby
#
# Acceptance tests for the meetup generator. Yeah, I know.
#
require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'
require 'rack/test'
require 'pathname'
require 'json'
require 'yaml'
require 'cgi'

ROOT = Pathname.new(__FILE__).realpath.dirname.parent

OUTER_APP = Rack::Builder.parse_file((ROOT + 'config.ru').to_s).first

class TestApp < MiniTest::Unit::TestCase
  attr_reader :things
  include Rack::Test::Methods

  def initialize(args)
    super(args)
    @things = YAML.load(IO.read(ROOT + 'lib' + 'all_the_things.yaml'))
  end

  def app
    OUTER_APP
  end

  def test_default
    #
    # Get all of the templates used to generate talk titles, and re-run
    # the test until we've seen them all. Then we know no template
    # causes a crash. That's good enough.
    #
    templates = things[:template].map do |t|
      escaped = Regexp.escape(CGI.escapeHTML(t))
      matcher = escaped.gsub(/%\w+%/, '\w+').gsub(/RAND\d+/, '\d+')
      Regexp.new('^.*ttitle">' + matcher  + '</span>.*$')
    end

    until templates.empty?
      get '/'
      assert last_response.ok?
      assert last_response.header['Content-Type'] == 'text/html;charset=utf-8'
      x = last_response.body
      assert_match(/The code./, x)
      assert_match(/DevOps Meetup/, x)
      templates.each { |t| templates.delete(t) if x.match(t) }
    end
  end

  def test_api
    get '/api/talk'
    assert last_response.ok?
    assert last_response.header['Content-Type'] == 'application/json'
    resp = last_response.body
    refute_empty resp
    j = JSON.parse(resp)
    fields = %w(talk talker role company)
    assert_equal(j.keys, fields)
    fields.each { |f| refute_empty j[f] }
    name = j['talker'].split
    assert_includes(things[:first_name], name.first)
    assert_includes(things[:last_name], name.last)
    assert j['company'].end_with?('.io')
  end

  def test_api_404
    get '/api/no_such_thing'
    assert_equal(last_response.status, 404)
  end
end