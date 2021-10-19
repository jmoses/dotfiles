#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'net/http'
require 'uri'
require 'id3lib'
require 'hpricot'
require 'cgi'
require 'ruby-growl'

class SimpleGrowl
  def self.set_password(str)
    @@password = str
  end
  
  def self.notify( msg, title = "SimpleGrowl Notification")
    @@growl ||= Growl.new('localhost', 'SimpleGrowl', %w( notification ), %w(notification), (@@password or nil) )
    
    @@growl.notify('notification', title, msg )
  end
end

SimpleGrowl.set_password('growl')

cts = open(ARGV[0], 'r') {|f| f.read }
doc = Hpricot(cts)

READ_SIZE = 1024 * 50

playlist_url = nil

(doc/"a").each do |ele|
  if ele['href'] =~ /hifi.m3u/
    playlist_url = "http://www.magnatune.com/" + ele['href']
    break
  end
end

album_name, artist_name = nil, nil

preview_text = " (PREVIEW: buy it at www.magnatune.com)"

cts = open(playlist_url, 'r') {|f| f.read }

cts.split("\n").select {|l| l =~ /^http/ }.each do |mp3|
  filename = CGI.unescape(File.basename(mp3))
  
  File.open(filename, 'w') do |out|
    # puts "Fetching #{mp3}"
    Net::HTTP.get_response(URI.parse(mp3)) do |res|
      res.read_body do |chunk|
        out << chunk
      end
    end
  end
  
  tag = ID3Lib::Tag.new filename
  tag.artist = tag.artist.gsub(preview_text, "")
  artist_name = tag.artist unless artist_name
  
  tag.album = tag.album.gsub(preview_text, "")
  album_name = tag.album unless album_name
  
  tag.title = tag.title.gsub(preview_text, "")
  tag.update!
  
end
SimpleGrowl.notify("Down downloading #{album_name} by #{artist_name}", "Album Download Complete")
