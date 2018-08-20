#!/usr/bin/env ruby

require 'find'
require 'fileutils'

SRC_DIR = ARGV[1]
DEST_DIR = ARGV[0]

puts "updating #{DEST_DIR} with audio from #{SRC_DIR}"

remove = SRC_DIR.split("/").length
Find.find(SRC_DIR).each do |f|
  next if File.directory?(f)

  src = f

  #create the destination
  f = f.split("/").pop(remove).join("/")
  dst = File.join(DEST_DIR, f)

  next if File.exist?(dst)
  puts "#{src} -> #{dst}"
  FileUtils.mkdir_p(File.dirname(dst))
  FileUtils.copy_file(src, dst)
end

