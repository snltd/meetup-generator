#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rack/builder'

%w[minitest minitest/unit minitest/autorun rack/test pathname json
   yaml cgi nokogiri].each { |f| require f }

MGROOT = Pathname.new(__FILE__).realpath.dirname.parent

OUTER_APP = Rack::Builder.parse_file(MGROOT.join('config.ru').to_s)

# Acceptance tests for the meetup generator. Yeah, I know.
#
class TestApp < MiniTest::Test
  attr_reader :things

  include Rack::Test::Methods

  def initialize(args)
    super(args)
    @things = YAML.safe_load_file(MGROOT.join(
                                    'lib', 'all_the_things.yaml'
                                  ), symbolize_names: true)
  end

  def app
    OUTER_APP
  end

  # Load the page a thousand times and make sure no talk titles
  # occur twice
  #
  def test_no_repeats
    1000.times do
      html = Nokogiri::HTML(get('/').body)
      titles = html.css('span[class="ttitle"]').map(&:text)
      assert_equal(titles, titles.uniq)
    end
  end

  # Get all of the templates used to generate talk titles, and
  # re-run the test until we've seen them all. Then we know no
  # template causes a crash. That's good enough.
  #
  def test_default
    templates = things[:template].map do |t|
      escaped = Regexp.escape(CGI.escapeHTML(t))
      matcher = escaped.gsub(/%\w+%/, '[\w\-]+').gsub(/RAND\d+/, '\d+')
                       .gsub('FNOPS', '\w+')
      Regexp.new("^.*ttitle\">#{matcher}</span>.*$")
    end

    until templates.empty?
      get '/'
      assert_equal('text/html;charset=utf-8',
                   last_response.headers['Content-Type'])
      last_response.ok?
      resp = last_response.body
      assert_match(/The code./, resp)
      assert_match(/DevOps Meetup/, resp)
      templates.each { |t| templates.delete(t) if resp.match?(t) }
    end
  end

  def test_api_talker
    get format('/api/talker')
    assert last_response.ok?
    assert_instance_of(String, last_response.body)
    assert_match(/^"\w+ \w+"$/, last_response.body)
    assert last_response.headers['Content-Type'] == 'application/json'
  end

  def test_api_company
    get format('/api/company')
    assert last_response.ok?
    assert_instance_of(String, last_response.body)
    assert_match(/^"\w+.io"$/, last_response.body)
    assert last_response.headers['Content-Type'] == 'application/json'
  end

  def test_api_misc
    %w[title role refreshment location date].each do |word|
      get format('/api/%<word>s', word:)
      assert last_response.ok?
      assert_instance_of(String, last_response.body)
      assert last_response.headers['Content-Type'] == 'application/json'
    end
  end

  def test_api_talk
    get format('/api/talk')
    assert last_response.ok?
    assert_instance_of(String, last_response.body)
    as_obj = JSON.parse(last_response.body, symbolize_names: true)
    assert_equal(%i[title talker role company], as_obj.keys)
  end

  def test_api_agenda
    get format('/api/agenda')
    assert last_response.ok?
    assert_instance_of(String, last_response.body)
    agenda = JSON.parse(last_response.body, symbolize_names: true)
    assert_equal(%i[date location refreshment talks], agenda.keys.sort)

    agenda[:talks].each do |t|
      assert_equal(%i[title talker role company], t.keys)
    end

    assert_instance_of(String, agenda[:refreshment])
    assert_instance_of(String, agenda[:date])
    assert_instance_of(String, agenda[:location])
  end

  def test_api_not_found
    get '/api/no_such_thing'
    assert_equal(last_response.status, 404)
  end
end
