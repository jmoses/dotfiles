#!/usr/bin/env ruby

hosts = {:web => [], :db => [], :file => [] }

1.upto(7) {|i| hosts[:web] << "10.60.10.#{i}" }
1.upto(4) {|i| hosts[:db] << "10.60.20.#{i}" }
1.upto(2) {|i| hosts[:file] << "10.60.30.#{i}" }

if !ARGV[0] or (ARGV[0] != 'all' and ! hosts.keys.include?( ARGV[0].to_sym ))
  STDERR.puts("Hosts for #{ARGV[0]} not found")
  exit 1
end

which = hosts[ ARGV.shift.to_sym ]

unless which
  which = hosts.collect {|w,h| h }.flatten
end

ARGV.each do |filespec|
  puts "Copying #{filespec}"
  which.each do |host|
    puts " #{host}"
    
    `scp #{filespec} reso@#{host}:/tmp`
  end
end
