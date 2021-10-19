#!/usr/bin/env ruby

require 'yaml'

conf_file = "/home/jmoses/.rb_locations"
status_file = "/home/jmoses/.rb_location"

LOCATIONS = if File.exists?( conf_file )
  YAML.load( File.open(conf_file) {|r| r.read } )
else
  {}
end

#locations = {
#  "192.168.11.1|00:02:B9:A5:9F:32" => :work,
#}

gateway_ip = nil
gateway_mac = nil

verbose = ( ! ARGV.include?("-q") )
delay = ARGV.include?("-d")

if delay
  sleep(120)
end

`route -n`.split("\n").each do |line|
  if line =~ /^0\.0\.0\.0\s+(\d+\.\d+\.\d+\.\d+)\s+/
    gateway_ip = $1
    break
  end
end

if gateway_ip
  `ping -c 2 #{gateway_ip}`
  if `arp -a #{gateway_ip}` =~ /at (.*?) \[/
    gateway_mac = $1
  end
end

cur_loc = LOCATIONS["#{gateway_ip}|#{gateway_mac}"]
if cur_loc
  if verbose
    puts "You're at #{cur_loc.to_s}"
  else
    puts cur_loc.to_s
  end
else
  if verbose
    location = `Xdialog --stdout --inputbox "Where are we?" 200x120`.strip
    unless location.nil? or location.empty?
      location.downcase!
      LOCATIONS["#{gateway_ip}|#{gateway_mac}"] = location.to_sym
      puts "You're at #{location}"
    end
  else
    puts "unknown"
  end
end

File.open(status_file, 'w') {|f| f.write( cur_loc ) }
File.open(conf_file, 'w') {|f| YAML.dump(LOCATIONS, f) }
