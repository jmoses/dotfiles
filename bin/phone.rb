#!/usr/bin/env ruby

require 'uri'
require 'net/http'

url = "http://10.10.2.234/~resonet/search.phtml"

search = ARGV[0]

unless search and ! search.empty?
  search = `Xdialog --stdout --inputbox "Name?" 200x120`
end

params = {"search" => search.strip}

exit if params["search"].nil? or params["search"].empty?

res = Net::HTTP.post_form( URI.parse( url ), params )
names = {}
name,number = nil, nil
res.body.each_line do |line|
  if line =~ /<b>([a-zA-z\-_]+)\s*,\s*(\w+)<\/b><br>/
    name = "#{$2} #{$1}"
  end

  if line =~ /^\s*(\d{3})\s*<\/td>\s*$/
    number = $1
  end

  if name and number
    names[name] = number
    name,number = nil, nil
  end

end

text = ""
names.each_pair {|n,u| text << "#{n} - #{u}\n" }
text = "No results for #{search}" if text.empty?

puts text

#`Xdialog --msgbox "#{text}" 250x200`
