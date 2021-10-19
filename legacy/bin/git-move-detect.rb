#!/usr/bin/env ruby

directory_level = ARGV[0]

added_files = []
deleted_files = []

`git status --porcelain`.split("\n").each do |line|
  if line =~ /^\?\? (.*)/
    added_files << $1
  elsif line =~ /^ D (.*)/
    deleted_files << $1
  end
end

pairs = []


deleted_files.each do |d|
  if matches = added_files.select {|a| File.basename(a) == File.basename(d) } and matches.size == 1
    # puts "Found moved file: #{d}, #{matches.first}"
    `git rm "#{d}"`
    `git add "#{matches.first}"`
  end
end


