#!/usr/bin/env ruby

%w(json yaml sinatra slim pathname).each { |r| require r }

#-----------------------------------------------------------------------------
# METHODS
#
class Meetup
  attr_reader :words, :lib, :talk, :talker, :refreshment

  def initialize
    @words = `/bin/grep "^[a-z]*$" #{find_dict}`.split("\n")
    @lib = YAML.load_file(Pathname(__FILE__).dirname + 'lib' +
                          'all_the_things.yaml')
  end

  def find_dict
    %w(dict lib/dict).each do |d|
      dict = Pathname.new('/usr/share') + d + 'words'
      puts "dict is #{dict}"
      return dict if dict.exist?
    end
    abort('Cannot find dictionary file.')
  end

  def talk
    t = lib[:template].sample
    t.scan(/%\w+%/).each { |k| t = t.sub(k, lib[k[1..-2].to_sym].sample) }
    t.scan(/RAND\d+/).each do |i|
      t = t.sub(i, rand(2..(i.sub(/RAND/, '').to_i)).to_s)
    end
    t
  end

  def talks(count = 5)
    ret = []
    until ret.size == count do
      t = talk
      ret.<< t unless ret.include?(t)
    end
    ret
  end

  def talker
    { talker: [lib[:first_name].sample, lib[:last_name].sample].join(' '),
      role: [lib[:job_role].sample, lib[:job_title].sample].join(' '),
      company: words.sample.sub(/([^aeiou])er$/, "\\1r") + '.io' }
  end

  def refreshment
    [lib[:food_style].sample, lib[:food].sample].join(' ')
  end
end

#-----------------------------------------------------------------------------
# SCRIPT STARTS HERE
#
m = Meetup.new

get '/api/talk' do
  content_type :json
  { talk: m.talk }.merge(m.talker).to_json
end

get '/api/*' do
  [404, 'not found']
end

get '*' do
  @talks, @jobs = m.talks, []
  5.times do
    t = m.talker
    @jobs.<< [t[:talker], '//', t[:role], '@', t[:company]].join(' ')
  end
  @food = m.refreshment
  slim :default
end
