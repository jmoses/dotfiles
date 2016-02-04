#!/usr/bin/env ruby

host = ARGV[0]
gate = ( ARGV[1] or 'igor' )

ip = `grep #{host} /etc/hosts`.split(" ")[0]

if ip.nil? or ip.empty? or ip.strip.empty?
  puts "Can't find host #{host}"
  exit 1
end

port = 2222 + ip.split('.')[3].to_i

tun_cmd = "slogin -fL #{port}:#{ip}:22 #{gate} sleep 3"
log_cmd = "slogin -p #{port} deploy@localhost"

exec("#{tun_cmd} && #{log_cmd}")