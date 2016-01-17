#!/usr/bin/env ruby

require 'find'

versions = {}

Find.find('.') do |f|
  if File.directory?(f) and ( File.basename(f) == '.svn' or f =~ /public\/images$/ or f =~ /coverage$/ or f =~ /index$/ ) 
    puts "Pruning #{f}"
    Find.prune
  end
  
  if `svn info "#{f}"` =~ /Revision: (\d+)/
    ( versions[$1] ||= [] ) << f
  end
end

versions.each_pair do |rev, files|
  puts "Rev #{rev} has #{files.size} files"
end
