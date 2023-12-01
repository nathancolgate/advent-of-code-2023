require 'humanize'

input = File.read(File.expand_path("./input.txt"))
calibration_values = input.split("\n")
# TIL: Look behinds in Regex
# https://mtsknn.fi/blog/how-to-do-overlapping-matches-with-regular-expressions/
#
# I had to use this to identify the last
# value in strings with overlapping charachters
# For example:
# 5twoone
# Would return 5 and two
#
# Normal regex "consumes" the "two", leaving only "ne" which does not match
# The looking behind captures the one as the last match.
# That was funky.
r = /(?=((\d{1}|one|two|three|four|five|six|seven|eight|nine|zero)))/
my_map = {}
(1..9).each do |n|
  my_map[n.to_s] = n
  my_map[n.humanize] = n
end

adjusted_values = calibration_values.map do |v|
  a = v.scan(r).first.first
  b = v.scan(r).last.first
  a2 = my_map[a]
  b2 = my_map[b]
  c = "#{a2}#{b2}".to_i
  c
end

puts adjusted_values.length
puts adjusted_values.sum
