#!/usr/bin/env ruby

hosts = %w( 10.60.10.1 10.60.10.2 10.60.10.3 10.60.10.4 10.60.10.5 10.60.10.6 10.60.10.7 )
# cmd = "slogin lighttpd@%s 'bash bin/restart_mongrels.sh'"

# cmd = "slogin reso@%s 'cd /u/apps/reso-shop/current && mongrel_rails cluster::stop && mongrel_rails cluster::stop -f && rm -f tmp/pids/mongrel*.pid && mongrel_rails cluster::start && ruby /usr/lib/nagios/plugins/check_mongrels.rb'"
cmd = "slogin reso@%s 'cd /u/apps/reso-shop/current && mongrel_rails cluster::stop && mongrel_rails cluster::stop -f && rm -f tmp/pids/mongrel*.pid'" #" && mongrel_rails cluster::start && ruby /usr/lib/nagios/plugins/check_mongrels.rb'"

rod_cmd = "slogin lighttpd@%s 'cd /u/apps/order-delivery/current && mongrel_rails cluster::stop && mongrel_rails cluster::stop -f && rm log/mongrel*.pid && mongrel_rails cluster::start'"

if ENV['FAST']
  threads = []
  hosts.each do |h|
    threads << Thread.new(h) do |host|
      puts `#{cmd % host}`
      if ENV['ALL'] and %w( 10.60.10.4 10.60.10.5 ).include?(host)
        puts `#{rod_cmd % host}`
      end
    end
  end
  threads.each {|t| t.join }
else
  hosts.each do |host|
    puts host
    puts `#{cmd % host}`

    if ENV['ALL'] and %w( 10.60.10.4 10.60.10.5 ).include?(host)
      puts `#{rod_cmd % host}`
    end

    sleep 5
  end
end
