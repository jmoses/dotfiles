#!/usr/bin/env ruby

@type = ARGV[0]
@isbn = ARGV[1]
@fix = ARGV[2]

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
  
  @regexp = /^#{@isbn}_oeb_c(\d+)_r1\.htm$/
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

files.each do |file|
  body = File.read( file )
  
  case @fix
  when 'end_link'
    body = body.split("\n").collect do |line|
      if line =~ /link.*[^\/]>$/
        line.gsub(/>$/, "/>")
      else
        line
      end
    end.join("\n")
  end
  
  File.open(file, 'w') {|f| f << body }
end