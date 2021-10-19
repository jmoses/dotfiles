#!/usr/bin/env ruby

require 'rexml/document'

@type = ARGV[0]
@isbn = ARGV[1]

if @type == 'baen'
  unless @isbn and @isbn.size > 0
    STDERR.puts("Please supply a base filename.")
    exit(1)
  end
  @regexp = /^#{@isbn}_+(\d+)\.htm$/ 
elsif @type == 'oeb'
  unless @isbn and @isbn.size > 0
    STDERR.puts("Please supply a base filename.")
    exit(1)
  end
  
  @regexp = /^#{@isbn}_oeb_c(\d+)_r1\.[x]{0,1}htm[l]{0,1}$/
elsif @type == 'normal'
  @regexp = /^(.*)\.htm[l]{0,1}$/
end


files = []
Dir["*"].each do |file|
  files << file if file.match( @regexp )
end

if @type == 'normal'
  files = files.sort
else
  files = files.sort {|x,y| x.match(@regexp)[1].to_i <=> y.match(@regexp)[1].to_i }
end

master_content = REXML::Document.new
html = master_content.add_element("html")
head = html.add_element("head")
style = head.add_element("link")

style.add_attribute("rel", "stylesheet")
style.add_attribute("href", "file:///Users/jmoses/book_library/style.css")

body = html.add_element("body")

puts "Pre flight checking in progress..."
pass = true
files.each do |file|
  File.open( file ) do |f|
    begin 
      doc = REXML::Document.new( f )
    rescue
      puts "-"*80
      puts "Error parsing chapter #{file.match(@regexp)[0]}."
      puts $!.message
      puts $!.backtrace.join("\n")
      puts "-"*80
      pass = false
    end
  end
end

unless pass
  puts " files invalid!"
  exit(1)
end

puts " completed ok!"

files.each do |file|
  File.open( file ) do |f|
    puts "Chapter #{file.match(@regexp)[0]}..."
    last = nil
    begin 
      doc = REXML::Document.new( f )
      doc.elements["html/body"].elements.each do |e|
        case e.name
          when 'a'
            next
          when 'img'
            next

          when 'p'
            e.delete_attribute("onmouseover")
            if last == 'h1'
              e.add_attribute("class", "firstpar")
            end

            if e.text and e.text.strip == "" and e.children.size == 1
              e.add_attribute("class", "break")
            end
            
            e.delete_element e.elements["//a"]

          when 'h1'
            e.add_attribute("class", 'chapterhead')

          when 'div'
            
            if e.attributes["align"] == "center"
              body.add_element("p").add_attribute("class", "break")
              next
            end
            
            if e.attributes["class"].to_s == 'tx'
              p = body.add_element("p")
              p.add_text( e.text )
              next
            end
            
            if e.attributes['class'].to_s == 'tx1'
              p = body.add_element("p")
              p.add_attribute("class", "firstpar")
              p.add_text( e.text )
              next              
            end
            
        end

        $stdout.print('.'); $stdout.flush
        body.add_element( e )

        last = e.name
      end
    rescue
      puts "Error parsing chapter."
      puts $!.message
      puts $!.backtrace.join("\n")
      puts "-"*80
      exit(1)
    end
    puts
  end
end

File.open("#{@isbn}_full.html", 'w') do |output|
  output << master_content.to_s #master_content.write( output, 0 )
end
