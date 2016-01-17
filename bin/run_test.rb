#!/usr/bin/env ruby
require 'pathname'

file = ARGV[0]

dir = File.dirname( file )

parts = dir.split("/")

real_parts = []

parts.each {|pa|  break if pa == 'test'; real_parts << pa }

base_dir = File.join( real_parts )

base = Pathname.new( base_dir )
source = Pathname.new( file )
target = source.relative_path_from(base).to_s

unit_or_functional = file =~ /\/unit\// ? 'unit' : 'functional'

exec "cd #{base_dir} && rake test:#{unit_or_functional}s:nodb TEST=#{target}"