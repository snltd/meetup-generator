# frozen_string_literal: true

require 'yaml'
require 'date'
require 'zlib'

LIB = Pathname.new(__dir__)

# Everything needed for a meetup generator
#
class MeetupGenerator
  attr_reader :words, :lib

  def initialize
    @words = Zlib::GzipReader.open(LIB.join('words.gz')).readlines.map(&:strip)
    @lib   = YAML.safe_load_file(LIB.join('all_the_things.yaml'),
                                 symbolize_names: true)
  end

  # @param num [Integer] how many talks you want
  # @return [Hash] full meetup agenda
  #
  def agenda(num = 5)
    { talks: lib[:template].sample(num).map { |t| talk(t) },
      refreshment:,
      location:,
      date: }
  end

  # @param templates [Array[String]] array of templates
  #
  def talk(template = random_template)
    { title: "#{title(template)} With AI",
      talker:,
      role:,
      company: }
  end

  def location
    'Shoreditch, probably'
  end

  def date
    (Date.today + 1).strftime('%d/%m/%Y')
  end

  def title(template = random_template)
    replace_word(replace_number(replace_ops(replace_things(template))))
  end

  def random_template(number = 1)
    lib[:template].sample(number).first
  end

  def talker
    pair(:first_name, :last_name)
  end

  def role
    pair(:job_role, :job_title)
  end

  def refreshment
    pair(:food_style, :food)
  end

  def company
    format('%<word>s.io', word: words.sample.sub(/([^aeiou])er$/, '\\1r'))
  end

  def something_ops
    "#{(lib[:something_ops] * 4).sample(rand(2..4)).join}Ops"
  end

  def pair(list1, list2)
    [lib[list1].sample, lib[list2].sample].join(' ')
  end

  def replace_things(template)
    return template unless template =~ /%[a-z_]+%/

    replace_things(template.sub(/%([a-z_]+)%/) do
      lib[Regexp.last_match(1).to_sym].sample
    end)
  end

  def replace_word(template)
    return template unless template.include?('%WORD%')

    replace_word(template.sub('%WORD%', words.sample.capitalize))
  end

  def replace_ops(template)
    return template unless template.include?('%FNOPS%')

    replace_ops(template.sub('%FNOPS%', something_ops))
  end

  def replace_number(template)
    return template unless template =~ /%RAND\d+%/

    replace_number(template.sub(/%RAND(\d+)%/) do
      rand(2..Regexp.last_match(1).to_i).to_s
    end)
  end
end
