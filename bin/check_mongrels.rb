#!/usr/bin/env ruby

require 'open-uri'
require 'timeout'
require 'fileutils'

def restart(port)
  rr = "/var/www/reso-shop"
  `mongrel_rails stop -P #{rr}/tmp/pids/mongrel.#{port}.pid -w5 -f`
  begin
    FileUtils.rm("#{rr}/tmp/pids/mongrel.#{port}.pid")
  rescue Errno::ENOENT
    puts " pid file not present."
  end
  `mongrel_rails start -p #{port} -P #{rr}/tmp/pids/mongrel.#{port}.pid -e production -d`
end

host = "localhost"
urls = []

8000.upto(8009) do |i|
  urls << "http://#{host}:#{i}/"
end

stop = false
status = {}

while !stop do 
puts "Checking..."

8000.upto(8009) do |port|
  s = Time.now
  u = "http://#{host}:#{port}/"
  cts = ""
  begin
    Timeout.timeout(15) do 
      cts = open(u) {|f| f.read }
    end
  rescue Timeout::Error
  end
  e = Time.now
  if cts =~ /id="body-wrapper"/
    puts "#{u} is good (#{e-s}s)"
  else
    last = ( status[port] or nil )
    status[port] = Time.now
    restart(port) unless ENV['JUST_CHECK']
    puts "#{u} is bad, restarted.  #{last ? "Lived #{status[port] - last}": '' }"
  end
  
end

puts "Sleeping..."
sleep 60 unless stop

end

puts "Stopped at #{Time.now}"
