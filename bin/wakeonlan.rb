#!/usr/bin/env ruby
# 
# wakeonlan.rb - Wake a sleeping computer from another machine on the network
# Copyright (C) 2004 Kevin R. Bullock <kbullock@ringworld.org>
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# 

WOL_VERSION = "wakeonlan.rb version 0.2.1"

require 'socket'

class WakeOnLAN
    
    include Socket::Constants
    
    # Exceptions
    class AddressException < RuntimeError; end
    class SetupException < RuntimeError; end
    
    # Regular Expression constants for hardware and IP addresses
    RE_MAC_ADDR = Regexp.new( '^' + (('[0-9A-Fa-f]' * 2).to_a * 6).join(':') + '$' )
    RE_IP_ADDR = Regexp.new( '^' + ('(([0-9][0-9]?)|([01][0-9][0-9])|(2[0-4][0-9])|(2[0-5][0-5]))'.to_a * 4).join('\.') + '$' )
    
    # Constructor method
    def initialize( mac = nil, ip = nil )
        
        if mac.nil?
            @magic = nil; @ip_addr = nil
        elsif ip.nil?
            self.setup( mac )
        else
            self.setup( mac, ip )
        end
        
    end #initialize()
    
    # Packet set-up method. Keeping this out of the constructor allows a
    # single WakeOnLAN object to be re-used for multiple addresses.
    def setup( mac, ip = '255.255.255.255' )
        
        @magic ||= ("\xff" * 6)
        
        # Validate MAC address and craft the magic packet
        raise AddressException,
            'Invalid MAC address' unless self.valid_mac?( mac )
        mac_addr = mac.split(/:/).collect {|x| x.hex}.pack('CCCCCC')
        @magic[6..-1] = (mac_addr * 16)
        
        # Validate IP address
        raise AddressException,
            'Invalid IP address' unless self.valid_ip?( ip )
        @ip_addr = ip
        
    end #set_up()
    
    def valid_mac?( mac )
        if mac =~ RE_MAC_ADDR then true
        else false
        end
    end #valid_mac?()
    
    def valid_ip?( ip )
        if ip =~ RE_IP_ADDR then true
        else false
        end
    end #valid_ip?()
    
    def send_wake()
        
        raise SetupException,
            'Tried to send packet without setting it up' unless @magic
        
        sock = UDPSocket.new
        sock.setsockopt( SOL_SOCKET, SO_BROADCAST, 1 )
        sock.connect( @ip_addr, Socket.getservbyname( 'discard', 'udp' ) )
        sock.send( @magic, 0 )
        
    end #send_wake()

end #class WakeOnLAN

if __FILE__ == $0
    require 'getoptlong'
    
    # Method to print the version and copyright info
    def version()
        $stderr.puts WOL_VERSION
        $stderr.puts 'Written by Kevin R. Bullock.'
        $stderr.puts
        $stderr.puts 'Copyright (C) 2004 Kevin R. Bullock.'
        $stderr.puts 'This is free software; see the source for copying conditions. There is NO'
        $stderr.puts 'warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'
    end
    
    # Method to print the help text
    def usage()
        $stderr.puts "Usage:\t#{$0} [options] xx:xx:xx:xx:xx:xx"
        $stderr.puts "Wake the sleeping computer with MAC address xx:xx:xx:xx:xx:xx from another\nmachine."
        $stderr.puts
        $stderr.puts "\t-i, --ip=ip_addr\tSpecify IP address to send the wake packet to"
        $stderr.puts "\t-h, --help\t\tPrint this usage summary"
        $stderr.puts "\t-v, --version\t\tPrint version information"
    end
    
    # Process command-line options
    opts = GetoptLong.new(
        ['--ip',      '-i', GetoptLong::REQUIRED_ARGUMENT],
        ['--help',    '-h', GetoptLong::NO_ARGUMENT],
        ['--version', '-v', GetoptLong::NO_ARGUMENT])
    ip = nil
    begin
        opts.each do |opt, arg|
            case opt
                when '--ip'      then ip = arg
                when '--help'    then usage(); exit(0)
                when '--version' then version(); exit(0)
            end
        end
    rescue
        exit(1)
    end
    
    # Check for at least one non-option argument
    unless ARGV[0]
        usage()
        exit(1)
    end
    
    begin
        wol = WakeOnLAN.new
        
        ARGV.each do |addr|
            if ip then wol.setup( addr, ip )
            else wol.setup( addr )
            end
        
            $stderr.print "Sending wake packet for #{addr}"
            $stderr.print " to #{ip}" if ip
            $stderr.print "..."
            wol.send_wake()
            $stderr.print "done.\n"
        end

    rescue WakeOnLAN::AddressException
        $stderr.puts $!
        usage()
        exit(1)
    rescue
        $stderr.print "\nError: #{$!}\n"
        exit(1)
    end
    
    begin
    end
end
