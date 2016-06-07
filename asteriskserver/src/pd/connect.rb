#!/usr/bin/env ruby

x = `jack_lsp -c`

sip_in = nil
sip_out = nil

arr = []
x.each_with_index do |l, index|
  l = l.chomp
  arr << l
  if l =~ /\A\s+/
    system("jack_disconnect #{arr[index - 1]} #{l}")
  end
  sip_in = l if l =~ /\ASIP.*input/
  sip_out = l if l =~ /\ASIP.*output/
end

system("jack_connect pure_data_0:output0 #{sip_in}")
system("jack_connect #{sip_out} pure_data_0:input0")
