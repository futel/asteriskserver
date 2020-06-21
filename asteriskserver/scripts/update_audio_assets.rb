#!/usr/bin/env ruby

# copy and normalize assets into source directory
# usage: update_audio_assets <dest_dir> <src_dir>


#https://wiki.asterisk.org/wiki/display/AST/Asterisk+10+Codecs+and+Audio+Formats

require 'find'
require 'fileutils'
require 'sndfile'

OUTPUT_MP3 = false #make true if we want to re-encode mp3s as mp3 for the output
SOX_COMPAND = "compand 0.14,1 6:-70,-24,-4.8 -8 -90 0.2"

SRC_DIR = ARGV[1]
DEST_DIR = ARGV[0]

puts "updating #{DEST_DIR} with audio from #{SRC_DIR}"

SLN_EXT = {
  8_000 => "sln",
  12_000 => "sln12",
  16_000 => "sln16",
  22_050 => "sln16",            # XXX will this just sound bad?
  24_000 => "sln24",
  32_000 => "sln32",
  44_100 => "sln44",
  48_000 => "sln48",
  96_000 => "sln96",
  192_000 =>"sln192"
}

known_ext = SLN_EXT.values + ["mp3", "gsm"]

script_mtime = File.mtime(__FILE__)

def get_extension(info) 
  out_ext = SLN_EXT[info.samplerate]
  raise "#{src} has an unsuppored sampling rate of #{info.samplerate}" unless out_ext
  return out_ext
end

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

  #make the dir
  FileUtils.mkdir_p(File.dirname(dst))

  #convert mp3 to wav and use the info for the destination
  if src_ext == ".mp3"
    if OUTPUT_MP3
      out_ext = 'mp3'
    else
      wav = base + "-tmp.wav"
      raise "MP3 cannot create tmp wav from #{out_ext}" unless system("sox", src, wav)
      cleanup << wav
      src = wav
    end
  end

  unless OUTPUT_MP3 and src_ext == ".mp3"
    info = Sndfile::File.info(src)
    out_ext = get_extension(info)
    is_raw = true
  end

  dst = base + "." + out_ext
  #ditch if the file exists and the dest is newer
  next if File.exist?(dst) and File.mtime(dst) > File.mtime(src) and File.mtime(dst) > script_mtime

  #report
  puts "#{src} -> #{dst}"

  #convert to wav if we haven't already
  if wav.nil?
    wav = base + "-tmp.wav"
    raise "cannot create tmp wav from #{out_ext}" unless system("sox", src, wav)
    cleanup << wav
    src = wav
    info = Sndfile::File.info(src)    
  end

  #make mono
  if info.channels != 1
    mono = base + "-tmp-mono.wav"
    raise "failed to make a mono file of #{src}" unless system("sndfile-mix-to-mono", src, mono)
    cleanup << mono
    src = mono
  end

  #band filter and sample rate change, before compression
  filtered = base + "-tmp-filtered.wav"
  raise "failed to filter audio" unless system("sox #{src} #{filtered} highpass 400 lowpass 3500 rate 8000 :")
  cleanup << filtered
  src = filtered

  # GROSS HACK, this shouldn't need to be done twice. Refactoring is needed.
  # Sample rate may have changed. Update info and extension (which is dependent on info.samplerate).
  info = Sndfile::File.info(src)
  out_ext = get_extension(info)
  dst = base + "." + out_ext
  
  #compress
  compressed = base + "-tmp-compressed.wav"
  raise "failed to apply dynamic range compression" unless system("sox #{src} -b 16 -c 1 #{compressed} #{SOX_COMPAND}")
  cleanup << compressed
  src = compressed

  #normalize the wav
  raise "failed to normalize" unless system("normalize-audio", "--quiet", src)

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

