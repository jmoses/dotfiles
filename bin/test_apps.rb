#!/usr/bin/env ruby

require 'net/http'

hosts = %w( 10.60.10.4 10.60.10.5 10.60.10.6 10.60.10.7 )
threads = []
hosts.each do |h|
  threads << Thread.new(h) do |h|
    status = `GET -sd http://#{h}/`
    if status =~ /200/
      puts "#{h}: OK"
    else
      puts "#{h}: #{status}"
    end
  end
end

threads.each { |aThread|  aThread.join }



