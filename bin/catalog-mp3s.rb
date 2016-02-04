#!/usr/bin/env ruby

require 'rubygems'
require 'id3lib'
require 'yaml'

catalog = if File.exists?("~/.mp3-catalog.yaml")
  YAML.load_file("~/.mp3-catalog.yaml")
else
  {}
end

Dir["#{ARGV[0]}/**/*"].each do |fname|
  if fname =~ /mp3$/
    tag = ID3Lib::Tag.new file
    catalog[tag.artist] ||= {}
    catalog[tag.artist][tag.album] ||= []
    catalog[tag.artist][tag.album]
  end
end 

