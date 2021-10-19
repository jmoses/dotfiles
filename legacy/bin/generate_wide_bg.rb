#!/usr/bin/ruby

# == Synopsis
#
# generate_wide.rb: Generate wide format backgrounds
#
# == Usage
#
# generate_wide.rb [OPTIONS]
#
# --input, -i
#   Input file name.
#
# --output, -o
#   Output file name.
#
# --action, -a
#   Which action to perform.
#
#   flip: Flip and duplicate the input file
#   resize: Just resize the input file
#   compose: Compose two image files into one, with resizing.
#
# --left, -l
#   Left side filename, used for 'compose'
#
# --right, -r
#   Right side filename, used for 'compose'

require 'RMagick'
require 'getoptlong'
require 'rdoc/usage'

opts = GetoptLong.new(
  [ '--input', '-i', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--output', '-o', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--action', '-a', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--left', '-l', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--right', '-r', GetoptLong::REQUIRED_ARGUMENT ]
)

input_fname = nil
left_fname = nil
right_fname = nil
output_fname = nil
action = :flip

opts.each do |opt, arg|
  case opt
    when '--input'
      input_fname = arg
    when '--output'
      output_fname = arg
    when '--left'
      left_fname = arg
    when '--right'
      right_fname = arg
    when '--action'
      action = arg.downcase.to_sym
  end
end

def usage
  RDoc::usage
  exit
end

## Sanity check
if ! [ :flip, :resize, :compose ].include?( action )
  usage
end

valid = true

case action
  when :flip
    if not input_fname
      puts "Input file name required."
      valid = false
    elsif not File.exists?(input_fname)
      puts "Input file doesn't exist"
      valid = false
    end

    if not output_fname
      puts "Output file name required."
      valid = false
    elsif File.exists?(output_fname)
      puts "Output filename exists, cowardly refusing to overwrite."
      valid = false
    end

  when :resize

    if not input_fname
      puts "Input file name required."
      valid = false
    elsif not File.exists?(input_fname)
      puts "Input file doesn't exist"
      valid = false
    end

    if not output_fname
      puts "Output file name required."
      valid = false
    elsif File.exists?(output_fname)
      puts "Output filename exists, cowardly refusing to overwrite."
      valid = false
    end

  when :compose
    [ left_fname, right_fname ].each do |fname|
      if not fname
        puts "Left and right files required."
        valid = false
      elsif not File.exists?(fname)
        puts "Left and right files required."
        valid = false
      end
    end

    if not output_fname
      puts "Output file name required."
      valid = false
    elsif File.exists?(output_fname)
      puts "Output filename exists, cowardly refusing to overwrite."
      valid = false
    end
end

unless valid
  usage
end

if action == :resize
  img = Magick::Image.read( input_fname ).first
  bg = img.resize( 3080, 1050 )
elsif action == :flip
  img = Magick::Image.read( input_fname ).first
  large = img.resize( 1680, 1050 )
  small = img.resize( 1400, 1050 )
  small.flop!

  bg = Magick::Image.new( 3080, 1050 )

  bg = bg.composite( small, 0, 0, Magick::CopyCompositeOp )
  bg = bg.composite( large, 1400, 0, Magick::CopyCompositeOp )
elsif action == :compose
  left = Magick::Image.read( left_fname ).first
  left = left.resize( 1400, 1050 )
  right = Magick::Image.read( right_fname ).first
  right = right.resize( 1680, 1050 )

  bg = Magick::Image.new( 3080, 1050 )

  bg = bg.composite( left, 0, 0, Magick::CopyCompositeOp )
  bg = bg.composite( right, 1400, 0, Magick::CopyCompositeOp )
end
bg.write( output_fname  )

