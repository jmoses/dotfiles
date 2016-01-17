#!/usr/bin/env ruby

require 'fileutils'
require 'tempfile'

@config_dir = File.expand_path( "~/bin/" )
@config_base = File.join( @config_dir, 'nginx-dir.conf' )
# From http://freelancing-gods.com/posts/script_nginx
puts "Starting Phusion Passenger via Nginx in #{FileUtils.pwd}:"

# Make directories if needed
%w( tmp log ).each do |dir|
  FileUtils.mkdir( dir ) unless File.exists?(dir)
end

port = (ARGV[0] || '3000')

tf = Tempfile.new("nginx-dir-#{port}")
tf << File.read( @config_base ).gsub(/%PORT%/, port )
tf.rewind

exec(%Q{/opt/nginx/sbin/nginx -p `pwd`/ -c #{tf.path} -g "error_log `pwd`/log/nginx.error.log; pid `pwd`/log/nginx.pid; ";})
