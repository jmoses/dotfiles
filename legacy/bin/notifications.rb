#!/usr/bin/env ruby

require 'rubygems'
require 'everyx'

## Just start nserver.
`nserver start`

weather = Everyx::PeriodicTasks::RSSNotifier.new
weather.uri = 'http://rss.wunderground.com/auto/rss_full/VT/Fairfield.xml?units=both'

#traffic = Everyx::PeriodicTasks::HTMLNotifier.new
#traffic.uri = 'http://67.106.3.242/default.asp?display=critical&area=VT_N&date=&textOnly=true'
#traffic.pattern = "//td[@bgcolor='#3366CC']//b"

e = Everyx::Everyx.new
e.every( (15*60), weather )
#e.every( (15*60), traffic )
e.join
