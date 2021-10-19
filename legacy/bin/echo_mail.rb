#!/usr/bin/env ruby


File.open('/home/jmoses/bin/maillog', 'r+') do |file|
  file << Time.now + "\n"
  STDIN.read {|c| file << c }
end
