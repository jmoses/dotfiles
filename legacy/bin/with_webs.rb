#!/usr/bin/env ruby

require 'rubygems'


webs = %w(
bb-app01
bb-app02
bb-app03
bb-app04
)

cmd = ARGV.join(' ')

which = ENV['tunnel'] ? '~/bin/tunnel.rb' : 'slogin'

webs.each do |w|
  puts w
  
  puts `#{which} #{w} \"#{cmd}\"`
end