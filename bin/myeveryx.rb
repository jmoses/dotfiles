#!/usr/bin/env ruby

require 'rubygems'
require 'everyx'
require 'nserver'

ex = Everyx::Everyx.new

rss = Everyx::PeriodicTasks::RSSNotifier.new
rss.uri = 'http://rss.wunderground.com/auto/rss_full/VT/Fairfield.xml?units=both'

ex.every((15 * 60), rss)


ex.join
