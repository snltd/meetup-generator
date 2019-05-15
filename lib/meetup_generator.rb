# frozen_string_literal: true

require 'json'
require 'yaml'

# Everything needed for a meetup generator
#
class MeetupGenerator
  attr_reader :words, :lib, :unused_templates

  def initialize
    grep, dict = find_unix_stuff
    @words     = `#{grep} "^[a-z]*$" #{dict}`.split("\n")
    @lib       = YAML.load_file(ROOT + 'lib' + 'all_the_things.yaml')
  end

  def find_unix_stuff
    case RUBY_PLATFORM
    when /solaris/
      %w[/bin/grep /usr/share/lib/dict/words]
    when /linux/
      %w[/bin/grep /usr/share/dict/words]
    when /darwin/
      %w[/usr/bin/grep /usr/share/dict/words]
    else
      abort "unsupported platform: #{RUBY_PLATFORM}"
    end
  end

  # @param num [Integer] how many talks you want
  # @return [Hash] full meetup agenda
  #
  def agenda(num = 5)
    { talks: lib[:template].sample(num).map { |t| talk(t) },
      refreshment: refreshment,
      location: location,
      date: date }
  end

  # @param templates [Array[String]] array of templates
  #
  def talk(template = random_template)
    { title: title(template),
      talker: talker,
      role: role,
      company: company }
  end

  def location
    'Shoreditch, probably'
  end

  def date
    (Date.today + 1).strftime('%d/%m/%Y')
  end

  def title(template = random_template)
    replace_number(replace_ops(replace_things(template)))
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
    format('%<word>s.io',
           word: words.sample.sub(/([^aeiou])er$/, '\\1r').downcase)
  end

  def something_ops
    rand(2..4).times.with_object(%w[Ops]) do |_i, a|
      a.prepend(lib[:something_ops].sample)
    end.join
  end

  def pair(list1, list2)
    [lib[list1].sample, lib[list2].sample].join(' ')
  end

  def replace_things(template)
    return template unless template =~ /%\w+%/

    replace_things(template.sub(/%(\w+)%/) do
      lib[Regexp.last_match(1).to_sym].sample
    end)
  end

  def replace_ops(template)
    return template unless template.include?('FNOPS')

    replace_ops(template.sub(/FNOPS/, something_ops))
  end

  def replace_number(template)
    return template unless template =~ /RAND\d+/

    replace_number(template.sub(/RAND(\d+)/) do
      rand(2..Regexp.last_match(1).to_i).to_s
    end)
  end
end
