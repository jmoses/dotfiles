#!/usr/bin/env ruby
require 'rubygems'
require 'time'

infile = 'fslme.hilis.srt'
outfile = 'fslme-adjusted.hilis.srt'

pattern = %r|(\d\d:\d\d:\d\d,\d\d\d) --> (\d\d:\d\d:\d\d,\d\d\d)|
format = "%H:%M:%S"

File.open( infile, 'r') do |input|
  File.open( outfile, 'w') do |output|
    input.each_line do |line|
      begin
        if line =~ pattern
          start_time = Time.parse($1)
          end_time = Time.parse($2)
        
          start_time = start_time + 4
          end_time = end_time + 4
        
          output << line.gsub(pattern, "#{start_time.strftime(format)},#{start_time.usec / 1000} --> #{end_time.strftime(format)},#{end_time.usec / 1000}")
        else
          output << line
        end
      rescue
        puts "Error with line: #{line}"
        exit 1
      end
    end
  end
end