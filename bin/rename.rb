#!/usr/bin/env ruby

Dir['/Users/jmoses/Music/**/*'].each do |f|
  next unless f =~ / 2\.m/
  
  directory = File.dirname(f)
  filename = File.basename(f)
  ext = File.extname(f)
  
  new_file = File.join(directory, filename.gsub(/ 2#{ext}$/, ext) )
  
  next if File.exists?( new_file )
  
  File.rename( f, new_file )
end