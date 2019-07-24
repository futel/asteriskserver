#!/usr/bin/env ruby

# copy and normalize assets into source directory
# usage: update_audio_assets <dest_dir> <src_dir>


#https://wiki.asterisk.org/wiki/display/AST/Asterisk+10+Codecs+and+Audio+Formats

require 'find'
require 'fileutils'
require 'sndfile'

SOX_COMPAND = "compand 0.3,1 6:-70,-60,-20 -5 -90 0.2"

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

script_mtime = File.mtime(__FILE__)

Find.find(SRC_DIR).each do |f|
  is_raw = false
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
    is_raw = true
    raise "#{src} has an unsuppored sampling rate of #{info.samplerate}" unless out_ext
  end

  dst = base + "." + out_ext
  #ditch if the file exists and the dest is newer
  next if File.exist?(dst) and File.mtime(dst) > File.mtime(src) and File.mtime(dst) > script_mtime

  #make the dir
  FileUtils.mkdir_p(File.dirname(dst))

  #report
  puts "#{src} -> #{dst}"

  #convert to wav
  wav = base + "-tmp.wav"
  raise "cannot create tmp wav from #{out_ext}" unless system("sox", src, wav)
  cleanup << wav
  src = wav

  if src_ext != ".mp3"  
    #make mono
    if info.channels != 1
      mono = base + "-tmp-mono.wav"
      raise "failed to make a mono file of #{src}" unless system("sndfile-mix-to-mono", src, mono)
      cleanup << mono
      src = mono
    end
  end

  #compress
  compressed = base + "-tmp-compressed.wav"
  raise "failed to apply dynamic range compression" unless system("sox #{src} #{compressed} #{SOX_COMPAND}")
  cleanup << compressed
  src = compressed

  #convert back to mp3
  if src_ext == ".mp3"  
    mp3 = base + "-tmp-mp3.mp3"
    raise "failed to encode to mp3" unless system("lame", "--quiet", src, mp3)
    src = mp3
    cleanup << mp3
  end

  #copy then normalize
  normalized = base + "-tmp-norm." + out_ext
  cleanup << normalized
  FileUtils.copy(src, normalized) #normalize happens in place, so copy the file first
  raise "failed to normalize" unless system("normalize-audio", "--quiet", "--peak", normalized)
  src = normalized

  #remove header if it is raw
  if is_raw
    raw = base + "-tmp.raw"
    raise "cannot create raw encoding" unless system("sndfile-convert", "-pcm16", src, raw)
    cleanup << raw
    src = raw
  end

  #copy to the final location
  FileUtils.copy(src, dst)

  #cleanup
  cleanup.each { |f| File.unlink(f) }
end

