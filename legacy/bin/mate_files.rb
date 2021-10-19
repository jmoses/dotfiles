#!/usr/bin/ruby

args = STDIN.read

filenames = args.split("\n").join(' ')

exec "mate #{filenames}"