#!/usr/bin/env ruby

# copy and normalize assets into source directory
# usage: update_audio_assets <dest_dir> <src_dir>


#https://wiki.asterisk.org/wiki/display/AST/Asterisk+10+Codecs+and+Audio+Formats

require 'find'
require 'fileutils'
require 'sndfile'

# usage:
# attack1,decay1{,attack2,decay2} [soft-knee-dB:]in-dB1[,out-dB1]{,in-dB2,out-dB2} [gain [initial-volume-dB [delay]]]
SOX_COMPAND = "compand 0.14,1 6:-70,-24,-4.8 -8 -90 0.2"

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


  # if src_ext == ".mp3"
  #   #convert to wav
  #   wav = base + "-tmp.wav"
  #   raise "cannot create tmp wav from #{out_ext}" unless system("sox", src, wav)
  #   cleanup << wav
  #   src = wav
  # end
    
  #convert to wav
  wav = base + "-tmp.wav"
  raise "cannot create tmp wav from #{out_ext}" unless system("sox", src, wav)
  cleanup << wav
  src = wav
  
  info = Sndfile::File.info(src)    
  out_ext = sln_ext[info.samplerate]
  is_raw = true
  raise "#{src} has an unsuppored sampling rate of #{info.samplerate}" unless out_ext

  dst = base + "." + out_ext
  #ditch if the file exists and the dest is newer
  next if File.exist?(dst) and File.mtime(dst) > File.mtime(src) and File.mtime(dst) > script_mtime

  #make the dir
  FileUtils.mkdir_p(File.dirname(dst))

  #report
  puts "#{src} -> #{dst}"

  # #convert to wav
  # # XXX
  # wav = base + "-foo.wav"
  # raise "cannot create tmp wav from #{out_ext}" unless system("sox", src, wav)
  # cleanup << wav
  # src = wav

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

