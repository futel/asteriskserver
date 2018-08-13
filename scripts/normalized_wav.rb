#!/usr/bin/env ruby

if ARGV.length == 0
  puts "usage #{$0} blah.gsm blah2.gsm"
end

ARGV.each do |f|
  b = File.basename(f, File.extname(f))
  wav = b + ".wav"
  raise "couldn't convert to #{f} to #{wav}" unless system('sndfile-convert', '-pcm16', f, wav)
  raise "couldn't normailze #{wav}" unless system('normalize-audio', '--peak', '--quiet', wav)
end
