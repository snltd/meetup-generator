#!/usr/bin/env ruby
#
require 'yaml'
require 'sinatra'
require 'haml'

if File.exist?('/usr/share/dict/words')
  words_file = '/usr/share/dict/words'
elsif File.exist?('/usr/share/lib/dict/words')
  words_file = '/usr/share/lib/dict/words'
else
  abort 'no words file'
end

things = YAML.load_file('all_the_things.yaml')

def generate_item(things)
  t = things[:template].sample
  t.scan(/%\w+%/).each { |k| t = t.sub(k, things[k[1..-2].to_sym].sample) }
  t.scan(/RAND\d+/).each do |i|
    t = t.sub(i, rand(i.sub(/RAND/, '').to_i).to_s)
  end
  t
end

def generate_job(things, words)
  [ things[:first_name].sample, things[:last_name].sample, '&mdash;',
    things[:job_role].sample, things[:job_title].sample, 'at',
    "#{words.sample}.io"
  ].join(' ')
end

words = `grep "^[a-z]*$" #{words_file}`.split("\n")

get '/' do
  @talks, @jobs = [], []
  5.times { @jobs.<< generate_job(things, words) }
  5.times { @talks.<< generate_item(things) }
  @food = "#{things[:food_style].sample} #{things[:food].sample}"
  haml :default
end
