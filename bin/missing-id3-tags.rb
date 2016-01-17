#!/usr/bin/env ruby

require 'rubygems'
require 'id3lib'
require 'yaml'

missing = {}

puts "Looking in #{ARGV[0]}"
current_dir = nil
Dir["#{ARGV[0]}/**/*"].each do |file|
  if File.dirname(file) != current_dir
    current_dir = File.dirname(file)
    puts "Looking in #{current_dir}"
  end

  if file =~ /mp3$/i
    tag = ID3Lib::Tag.new file
    miss = []
    %w( title album track artist ).each do |tname|
      val = tag.send( tname.to_sym )
      if val.nil? or val.empty?
        miss << tname
      end
    end
    missing[file] = miss unless miss.empty?
  end
end

if missing.size > 0
  missing.each_pair do |fname, fields|
    puts "#{File.basename(fname)} is missing #{fields.join(',')}"
  end
  File.open('results.yaml', 'w') do |out|
    YAML.dump(missing, out)
  end
else
  puts "All tracks ok."
end
