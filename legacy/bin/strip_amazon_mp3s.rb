#!/usr/bin/env ruby

require 'rubygems'
require 'id3lib'

Dir["#{ARGV[0]}/**/*"].each do |file|
  if file =~ /mp3$/i
    tag = ID3Lib::Tag.new file
    tag.delete_if{ |frame| frame[:id] == :COMM }
  end
end
