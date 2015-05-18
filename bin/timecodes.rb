#!/usr/bin/env ruby
require 'timecoder'

offset = nil

lines = File.readlines File.expand_path(ARGV[0])

lines.each do |line|
  if line =~ /\[(\d{2}\:\d{2})\] offset$/
    offset ||= Timecoder.timecode_to_seconds("00:" + $1)
  elsif offset && line =~ /\[(\d{2}\:\d{2})\] (.*)$/
    line_offset = Timecoder.timecode_to_seconds("00:" + $1)
    line_timecode = Timecoder.seconds_to_timecode(line_offset + offset)
    line_content = $2

    hours, minutes, seconds = line_timecode.split(":").map(&:to_i)
    minutes += (hours * 60) if hours > 0 # we'll never get to two hours, but stay safe
    formatted_timecode = sprintf("%02d:%02d", minutes, seconds)

    puts "[#{formatted_timecode}] #{line_content}"
  end
end
