#!/usr/bin/env ruby
require 'open-uri'
require 'timeout'


tracks = []
timeout(1) {
  open("http://ws.audioscrobbler.com/1.0/user/jmoses/recenttracks.txt") do |f|
    f.each {|t| tracks << t.split(',')[1, t.length] }
  end
}

puts tracks[0]
