#!/usr/bin/env ruby

x = `jack_lsp -c`

arr = []
x.each_with_index do |l, index|
  l = l.chomp
  arr << l
  if l =~ /\A\s+/
    system("jack_disconnect #{arr[index - 1]} #{l}")
  end
end

system("jack_connect pure_data_0:output0 SIP/720-00000000:input")
system("jack_connect SIP/720-00000000:output pure_data_0:input0")
