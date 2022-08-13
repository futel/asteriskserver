#!/usr/bin/env ruby

# copy and normalize assets into source directory
# usage: update_audio_assets <dest_dir> <src_dir>


#https://wiki.asterisk.org/wiki/display/AST/Asterisk+10+Codecs+and+Audio+Formats

require 'find'
require 'fileutils'
require 'sndfile'

OUTPUT_MP3 = false #make true if we want to re-encode mp3s as mp3 for the output
SOX_COMPAND = "compand 0.001,0.3 6:-30,-3 -6 -12 0.002"

SRC_DIR = ARGV[1]
DEST_DIR = ARGV[0]

puts "updating #{DEST_DIR} with audio from #{SRC_DIR}"

script_mtime = File.mtime(__FILE__)

Find.find(SRC_DIR).each do |f|
  is_raw = true
  out_ext = 'sln'

  cleanup = []
  next if File.directory?(f)

  src = f
  src_ext = File.extname(src)

  #create the destination
  f = f.split("/").last
  dst = File.join(DEST_DIR, f)
  base = File.join(File.dirname(dst), File.basename(dst, ".*"))

  #make the dir
  FileUtils.mkdir_p(File.dirname(dst))

  #convert mp3 to wav and use the info for the destination
  if src_ext == ".mp3"
    if OUTPUT_MP3
      out_ext = 'mp3'
      is_raw = false
    end
  end

  dst = base + "." + out_ext
  #ditch if the file exists and the dest is newer
  next if File.exist?(dst) and File.mtime(dst) > File.mtime(src) and File.mtime(dst) > script_mtime


  #report
  puts "#{src} -> #{dst}"

  # Combined signal chain (order is important):
  # * Convert to single channel (monophonic)
  # * Apply band filter from 300 Hz to 3.4kHz
  # * Normalize amplitude to -12dB RMS (with limiting to not clip)
  # * Convert sample rate to 8kHz
  # * Dynamic range compression
  processed = base + "-tmp-processed.wav"
  raise "failed to filter audio" unless system("sox #{src} #{processed} channels 1 sinc 300-3700 gain -n -b -12 rate 8000 #{SOX_COMPAND} :")
  cleanup << processed
  src = processed

  #remove header if it is raw
  if is_raw
    raw = base + "-tmp.raw"
    raise "cannot create raw encoding" unless system("sndfile-convert", "-pcm16", src, raw)
    cleanup << raw
    src = raw
  elsif out_ext == ".mp3" and OUTPUT_MP3 #convert back to mp3
    mp3 = base + "-tmp-mp3.mp3"
    raise "failed to encode to mp3" unless system("lame", "--quiet", src, mp3)
    src = mp3
    cleanup << mp3
  else
    raise "don't know what to do with #{src} -> #{dst}"
  end

  #copy to the final location
  FileUtils.copy(src, dst)

  #cleanup
  cleanup.each { |f| File.unlink(f) }
end

