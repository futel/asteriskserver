#!/usr/bin/env ruby

# copy and normalize assets into source directory
# usage: update_audio_assets <dest_dir> <src_dir>


#https://wiki.asterisk.org/wiki/display/AST/Asterisk+10+Codecs+and+Audio+Formats

require 'find'
require 'fileutils'
require 'sndfile'

SRC_DIR = ARGV[1]
DEST_DIR = ARGV[0]

puts "updating #{DEST_DIR} with audio from #{SRC_DIR}"

sln_ext = {
  8_000 => "sln",
  12_000 => "sln12",
  16_000 => "sln16",
  24_000 => "sln24",
  32_000 => "sln32",
  44_100 => "sln44",
  48_000 => "sln48",
  96_000 => "sln96",
  192_000 =>"sln192"
}

known_ext = sln_ext.values + ["mp3", "gsm"]

Find.find(SRC_DIR).each do |f|
  cleanup = []
  next if File.directory?(f)

  src = f
  src_ext = File.extname(src)

  #create the destination
  f = f.split("/").last
  dst = File.join(DEST_DIR, f)
  base = File.join(File.dirname(dst), File.basename(dst, ".*"))


  #simply copy mp3, if the source is newer
  if src_ext == ".mp3"
    out_ext = "mp3"
  else
    info = Sndfile::File.info(src)    
    out_ext = sln_ext[info.samplerate]
    raise "#{src} has an unsuppored sampling rate of #{info.samplerate}" unless out_ext
  end

  dst = base + "." + out_ext
  #ditch if the file exists and the dest is newer
  next if File.exist?(dst) and File.mtime(dst) > File.mtime(src)

  #make the dir
  FileUtils.mkdir_p(File.dirname(dst))

  #report
  puts "#{src} -> #{dst}"

  #convert gsm to wav so we can normalize
  if src_ext == ".gsm"
    wav = base + "-tmp.wav"
    raise "cannot create tmp wav from gsm" unless system("sndfile-convert", "-pcm16", src, wav)
    cleanup << wav
    src = wav
  end

  if src_ext != ".mp3"  
    #make mono
    if info.channels != 1
      mono = base + "-tmp-mono.wav"
      raise "failed to make a mono file of #{src}" unless system("sndfile-mix-to-mono", src, mono)
      cleanup << mono
      src = mono
    end
  end

  #copy then normalize
  FileUtils.copy(src, dst)
  raise "failed to normalize" unless system("normalize-audio", "--quiet", "--peak", dst)

  cleanup.each { |f| File.unlink(f) }
end

