Part = Struct.new(:number, :x, :y) do
  def valid?(markers)
    markers.select {|m| x_range === m.x && y_range === m.y}.any?
  end
  def self.regex
    /\d+/
  end
  def width
    number.to_s.length
  end
  def x_range
    ((x-1)..(x+width))
  end
  def y_range
    ((y-1)..(y+1))
  end
end

Marker = Struct.new(:char, :x, :y) do
  def self.regex
    /[^0-9\.]/
  end

  def gear_ratio(parts)
    mp = matching_parts(parts)
    mp.length == 2 ? mp.first.number * mp.last.number : 0
  end

  def matching_parts(parts)
    parts.select {|p| p.x_range === x && p.y_range === y}
  end
end

parts = []
markers = []
input = File.read(File.expand_path("./input.txt"))
lines = input.split("\n")
lines.each_with_index do |line,y|
  line.enum_for(:scan, Part.regex).each do |match|
    x = Regexp.last_match.begin(0)
    parts << Part.new(match.to_i, x, y)
  end
  line.enum_for(:scan, Marker.regex).each do |match|
    x = Regexp.last_match.begin(0)
    markers << Marker.new(match, x, y)
  end
end

puts markers.map {|m| m.gear_ratio(parts)}.sum

