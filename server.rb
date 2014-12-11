#!/usr/bin/env ruby

require 'yaml'
require 'sinatra'
require 'haml'
require 'pathname'

#-----------------------------------------------------------------------------
# METHODS
#
def generate_item(things)
  t = things[:template].sample
  t.scan(/%\w+%/).each { |k| t = t.sub(k, things[k[1..-2].to_sym].sample) }
  t.scan(/RAND\d+/).each do |i|
    t = t.sub(i, rand(2..(i.sub(/RAND/, '').to_i)).to_s)
  end
  t
end

def generate_job(things, words)
  [ things[:first_name].sample, things[:last_name].sample, '&mdash;',
    things[:job_role].sample, things[:job_title].sample, '@',
    "#{words.sample.sub(/([^aeiou])er$/, "\\1r")}.io"
  ].join(' ')
end

#-----------------------------------------------------------------------------
# SCRIPT STARTS HERE
wd = File.exist?('/usr/share/dict') ? '/usr/share/dict' : '/usr/share/lib/dict'
words = `/bin/grep "^[a-z]*$" #{Pathname(wd) + 'words'}`.split("\n")
things = YAML.load_file(Pathname(__FILE__).dirname + 'all_the_things.yaml')

get '/' do
  @talks, @jobs = [], []
  5.times { @jobs.<< generate_job(things, words) }
  5.times { @talks.<< generate_item(things) }
  @food = "#{things[:food_style].sample} #{things[:food].sample}"
  haml :default
end
