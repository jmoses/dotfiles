#!/usr/bin/env ruby

require 'rexml/document'
require 'digest/sha1'

def get_filelist( dir, ul_ele )
  Dir["#{dir}/*"].each do |file|
    if File.directory?(file)
      id = Digest::SHA1.hexdigest(file)
      li = ul_ele.add_element("li")
      li.add_attribute("class", "directory")
      link = li.add_element("a")
      link.add_attribute("href", "javascript:toggle('#{id}')")
      link.add_attribute("class", "directory")
      link.add_text file.gsub(/^\.\//, '' )
      ul = li.add_element("ul")
      ul.add_attribute("id", id)
      ul.add_attribute("class", "hide")
      get_filelist( file, ul )
    else
      link = ul_ele.add_element("li").add_element("a")
      link.add_attribute("href", file)
      link.add_text file.gsub(/^\.\//, '')
    end
  end
end

start_dir = ARGV[0]

if start_dir.nil? or start_dir.empty?
  puts "Please provide a directory."
  exit 1
end

doc = REXML::Document.new

html = doc.add_element("html")
head = html.add_element("head")
script = head.add_element("script")
script.add_attribute("type", "text/javascript")
script.add_attribute("src", "/home/jmoses/book_library/library.js")

style = head.add_element("link")
style.add_attribute("rel", "stylesheet")
style.add_attribute("href", "/home/jmoses/book_library/style.css")

body = html.add_element("body")
body.add_element("h1").add_text( start_dir + " Contents" )
ul = body.add_element("ul")
ul.add_attribute("class", "index")
get_filelist(start_dir, ul )

doc.write($stdout, 0)
puts
