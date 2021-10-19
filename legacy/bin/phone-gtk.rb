#!/usr/bin/env ruby

require 'gtk2'
require 'uri'
require 'net/http'

def get_number( name )
  url = "http://10.10.2.234/~resonet/search.phtml"
  params = {"search" => name.strip}
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
  names
end

def handle()
  names = get_number(@text)

  text = names.collect {|c| "#{c[0]} - #{c[1]}" }.join("\n")
  if text.strip == ""
    text = "No numbers found."
  end


  dialog = Gtk::Dialog.new("Test", nil, Gtk::Dialog::DESTROY_WITH_PARENT, [ Gtk::Stock::OK, Gtk::Dialog::RESPONSE_NONE])
dialog.signal_connect('response') { dialog.destroy; Gtk.main_quit; exit! }
dialog.vbox.add(Gtk::Label.new(text))
  
dialog.show_all
end

dialog = Gtk::Dialog.new("Test", nil, Gtk::Dialog::DESTROY_WITH_PARENT, [ Gtk::Stock::OK, Gtk::Dialog::RESPONSE_NONE])

@entry = Gtk::Entry.new
@entry.activates_default = true
@text = nil

dialog.signal_connect('response') do |d, respo|
  if respo == -1
    @text = @entry.text; dialog.destroy; handle()
  else
    dialog.destroy
    Gtk.main_quit
    exit!
  end
end
dialog.vbox.add(Gtk::Label.new("Testing..."))
dialog.vbox.add(@entry)
dialog.default_response = -1
dialog.show_all

Gtk.main
