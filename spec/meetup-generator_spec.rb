#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/meetup_generator'

THINGS = { food_style: %w[artisan],
           food: %w[flatbread],
           first_name: %w[John],
           last_name: %w[Smith],
           job_role: %w[Neckbeard],
           job_title: ['Without Portfolio'],
           tech: %w[Ruby],
           something_ops: %w[Dev Test No],
           template: ['RAND20 %tech% things'] }.freeze

# We don't want the class properly initialized
#
class Giblets < MeetupGenerator
  def initialize; end
end

# Test the uninitialized class
#
class GibletsTest < MiniTest::Test
  attr_reader :m

  def setup
    @m = Giblets.new
    m.instance_variable_set(:@lib, THINGS)
    m.instance_variable_set(:@words, %w[leadswinger])
  end

  def _test_title
    x = m.title
    assert_instance_of(String, x)
    assert !x.empty?
    refute_match(/%\w+%/, x)
    refute_match(/RAND/, x)
  end

  def test_agenda
    agenda = m.agenda(1)
    talks = agenda[:talks]

    assert_instance_of(Array, talks)
    assert_equal(1, talks.size)

    talk = talks.first
    assert_instance_of(Hash, talk)

    assert_equal(%i[title talker role company], talk.keys)
    tokens = talk[:title].split
    number = tokens.first.to_i
    assert number.positive?
    assert number <= 20
    assert_equal('Ruby', tokens[1])
    assert_equal('things', tokens[2])

    assert_equal('artisan flatbread', agenda[:refreshment])
  end

  def test_something_ops
    assert m.something_ops.is_a?(String)
    assert m.something_ops.end_with?('Ops')
  end

  def test_talker
    assert_equal(m.talker, 'John Smith')
  end

  def test_role
    assert_equal(m.role, 'Neckbeard Without Portfolio')
  end

  def test_company_no_e
    assert_equal(m.company, 'leadswingr.io')
  end

  def test_company
    m.instance_variable_set(:@words, %w[Cabbage])
    assert_equal(m.company, 'cabbage.io')
  end

  def test_refreshment
    assert_equal(m.refreshment, 'artisan flatbread')
  end

  def test_replace_things
    x = m.replace_things('%tech% is %tech%')
    assert_equal('Ruby is Ruby', x)
  end

  def test_replace_ops
    x = m.replace_ops('From FNOPS to FNOPS')
    assert_instance_of(String, x)
    assert_match(/From \w+Ops to \w+Ops$/, x)
  end

  def test_replace_number
    x = m.replace_number('RAND9 years and RAND5 months')
    assert_instance_of(String, x)
    assert_match(/\d years and \d months/, x)
  end
end
