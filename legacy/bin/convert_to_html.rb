#!/usr/bin/env ruby
require 'rubygems'
require 'htmlentities'

require 'rexml/document'

input_file = ARGV[0]

content = File.open( input_file, 'r') {|f| f.read }

master_content = REXML::Document.new
html = master_content.add_element("html")
head = html.add_element("head")
style = head.add_element("link")

style.add_attribute("rel", "stylesheet")
style.add_attribute("href", "/Users/jmoses/book_library/style.css")

body = html.add_element("body")
buffer = []
next_class = nil

split_on_line_break = false

coder = HTMLEntities.new

content.split("\n").each do |line|
  if line.strip == "" ## Empty line, new paragraph
    unless buffer.empty? #Don't add dup. empty pars.
      if (buffer.size == 1 and buffer.first =~ //) or (buffer.size == 1 and buffer.first.split(' ')[0].upcase == "CHAPTER" and buffer.first.split(' ').size == 2)
        c = body.add_element("h1")
        c.add_attribute("class", "chapterhead")
        c.text = buffer.join("\n").gsub(//, '')
        next_class = "firstpar"
      else
        if (buffer.first.split(" ")[0..5].join(" ").upcase == buffer.first.split(" ")[0..5].join(" ") or buffer.first == buffer.first.upcase) and buffer.size > 1
          next_class = "break toppad"
        end
        p = body.add_element("p")
        p.add_text( REXML::Text.new(coder.encode(buffer.join("\n"), :basic, :named), false, nil, true) )
        
        if next_class
          p.add_attribute("class", next_class)
          next_class = nil
        end

      end
      buffer = []
    end
  elsif split_on_line_break
    p = body.add_element("p")
    p.add_text( coder.encode(line, :basic, :named) )
    
  else
    buffer << line
  end
end

File.open( "#{input_file}.html", 'w') {|f| master_content.write(f, 0) }

