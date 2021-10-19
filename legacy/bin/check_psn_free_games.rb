#!/usr/bin/env ruby

require 'open-uri'
require 'digest/md5'
require 'rubygems'
require 'json'

"https://store.playstation.com/chihiro-api/viewfinder/US/en/999/STORE-MSF77008-PSPLUSFREEGAMES?size=30&gkb=1&geoCountry=US"
#games = JSON.parse( open('https://store.sonyentertainmentnetwork.com/chihiroview/viewfinder?https%3A%2F%2Fstore.sonyentertainmentnetwork.com%2Fstore%2Fapi%2Fchihiro%2F00_09_000%2Fcontainer%2FUS%2Fen%2F19%2FSTORE-MSF77008-PSPLUSFREEGAMES%3Fsize%3D30') {|f| f.read })
games = JSON.parse( open('https://store.playstation.com/chihiro-api/viewfinder/US/en/999/STORE-MSF77008-PSPLUSFREEGAMES?size=30&gkb=1&geoCountry=US') {|f| f.read })

short = games['links'].map do |game|
  "#{game['name']} (#{game['playable_platform'].join(', ')})"
end.sort

hash = Digest::MD5.hexdigest(short.join)

previous_hash = File.read(File.expand_path('~/.psn_free')).strip rescue nil

if hash != previous_hash
  File.open(File.expand_path('~/.psn_free'), 'w') {|f| f << hash }
  if ARGV[0]
    File.open(File.join(ARGV[0], Time.now.strftime('%Y%m%d_games.txt')), 'w') {|out| short.each {|g| out.puts g } } 
  else
    short.each {|g| puts g }
  end
end

