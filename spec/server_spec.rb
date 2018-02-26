#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../server'

THINGS = { food_style: %w[artisan],
           food:       %w[flatbread],
           first_name: %w[John],
           last_name:  %w[Smith],
           job_role:   %w[Neckbeard],
           job_title:  ['Without Portfolio'],
           tech:       %w[Ruby],
           template:   ['RAND20 %tech% things'] }.freeze

class Giblets < Meetup
  def initialize; end
end

class GibletsTest < MiniTest::Test
  attr_reader :m

  def setup
    @m = Giblets.new
    m.instance_variable_set(:@lib, THINGS)
  end

  def test_find_dict
    assert_instance_of(Pathname, m.find_dict)
  end

  def test_talk
    x = m.talks(1)
    assert_instance_of(Array, x)
    assert_instance_of(String, x.first)
    toks = x.first.split
    number = toks.first.to_i
    assert number > 0
    assert number < 20
    assert_equal('Ruby', toks[1])
    assert_equal('things', toks[2])
  end

  def test_talker
    assert_equal(m.talker, 'John Smith')
  end

  def test_role
    assert_equal(m.role, 'Neckbeard Without Portfolio')
  end

  def test_company_no_e
    m.instance_variable_set(:@words, %w[leadswinger])
    assert_equal(m.company, 'leadswingr.io')
  end

  def test_company
    m.instance_variable_set(:@words, %w[Cabbage])
    assert_equal(m.company, 'cabbage.io')
  end

  def test_refreshment
    assert_equal(m.refreshment, 'artisan flatbread')
  end
end
