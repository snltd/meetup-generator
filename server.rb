#!/usr/bin/env ruby

%w[json yaml sinatra slim pathname].each { |r| require r }

class Meetup
  attr_reader :words, :lib, :unused_templates

  def initialize
    grep, dict = case RUBY_PLATFORM
                 when /solaris/
                   %w[/bin/grep /usr/share/lib/dict/words]
                 when /linux/
                   %w[/bin/grep /usr/share/dict/words]
                 when /darwin/
                   %w[/usr/bin/grep /usr/share/dict/words]
                 else
                   abort "unknown platform #{RUBY_PLATFORM}"
                 end

    @words = `#{grep} "^[a-z]*$" #{dict}`.split("\n")
    @lib = YAML.load_file(Pathname.new(__FILE__).dirname + 'lib' +
                          'all_the_things.yaml')
  end

  def title
    unused_templates ||= lib[:template].dup
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
    count.times.with_object([]) { |_i, a| a.<< title }
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

  def talk
    { talk: talks(1)[0], talker: talker, role: role, company: company }
  end
end

m = Meetup.new

get '/api/:item?/?*' do
  content_type :json
  if m.respond_to?(params[:item]) && params[:item] != 'initialize'
    m.send(params[:item]).to_json
  else
    [404, 'not found']
  end
end

get '*' do
  @talks, @food = m.talks, m.refreshment
  @jobs = 5.times.with_object([]) do |_i, a|
    a.<< [m.talker, '//', m.role, '@', m.company].join(' ')
  end
  slim :default
end
