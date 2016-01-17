#!/usr/bin/env ruby

require 'rubygems'
require 'rbosa'

term = OSA.app(:path => "/Applications/Utilities/Terminal.app")

puts term.inspect
