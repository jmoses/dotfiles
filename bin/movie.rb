#!/usr/bin/env ruby

require 'fileutils'

base_or_file = ARGV[0]
cleaned = ARGV[1]

if base_or_file.to_s == ''
  puts "Must have at least args"
  exit 1
end

YIFY = cleaned.to_s == ''

def cleaned_name_from_yify(file)
  parts = File.basename(file).split('.')

  name = []
  year = nil

  parts.each do |part|
    if part =~ /^\d\d\d\d$/
      year = part
      break
    else
      name << part
    end
  end

  "#{name.join(' ')} (#{year})"
end

def move(source, new_name)
  ext = File.extname(source)
  target = File.join("/Volumes/Sneezy/movies", "#{new_name}#{ext}")

  puts "#{source} => #{target}"

  FileUtils.mv(source, target)
end

moved = false
if File.exists?(base_or_file)
  moved = true
  move(base_or_file, YIFY ? cleaned_name_from_yify(base_or_file) : cleaned)
else
  Dir["#{base_or_file}.*"].each do |f|
    if f.end_with?(".srt")
      moved = true
      move(f, "#{cleaned}.en")
    else
      moved = true
      move(f, cleaned)
    end
  end
end

if ! moved
  STDERR.puts "Did not move any files!"
end
