#!/usr/bin/env ruby

%w[json yaml sinatra slim pathname].each { |r| require r }

class Meetup
  attr_reader :words, :lib, :unused_templates

  def initialize
    @words = `/bin/grep "^[a-z]*$" #{find_dict}`.split("\n")
    @lib = YAML.load_file(Pathname.new(__FILE__).dirname + 'lib' +
                          'all_the_things.yaml')
  end

  def find_dict
    %w[dict lib/dict].each do |d|
      dict = Pathname.new('/usr/share') + d + 'words'
      return dict if dict.exist?
    end
    abort 'Cannot find dictionary file.'
  end

  def talk
    t = unused_templates.sample
    unused_templates.delete(t)
    t.scan(/%\w+%/).each { |k| t = t.sub(k, lib[k[1..-2].to_sym].sample) }
    t.scan(/RAND\d+/).each do |i|
      t = t.sub(i, rand(2..(i.sub(/RAND/, '').to_i)).to_s)
    end
    t
  end

  def talks(count = 5)
    @unused_templates = lib[:template].dup
    count.times.with_object([]) { |_i, a| a.<< talk }
  end

  def talker
    lib[:first_name].sample + ' ' + lib[:last_name].sample
  end

  def role
    lib[:job_role].sample + ' ' + lib[:job_title].sample
  end

  def company
    words.sample.sub(/([^aeiou])er$/, '\\1r').downcase + '.io'
  end

  def refreshment
    lib[:food_style].sample + ' ' + lib[:food].sample
  end
end

m = Meetup.new

get '/api/talk' do
  content_type :json
  { talk: m.talks(1)[0], talker: m.talker, role: m.role,
    company: m.company }.to_json
end

get '/api/*' do
  [404, 'not found']
end

get '*' do
  @talks, @food = m.talks, m.refreshment
  @jobs = 5.times.with_object([]) do |_i, a|
    a.<< [m.talker, '//', m.role, '@', m.company].join(' ')
  end
  slim :default
end
