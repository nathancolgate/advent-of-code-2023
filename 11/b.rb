class Galaxy
  attr_reader :x,:y
  def initialize(x,y)
    @x = x
    @y = y
  end
end

require 'colorize'

STAR_CHAR = '.'
GALAXY_CHAR = '#'

input = File.read(File.expand_path("./input.txt"))
rows = input.split("\n")


# Expand Galaxy Up and Down
galaxy_width = rows.first.each_char.to_a.length
allstar_rows = []
rows.each_with_index do |row,index|
  if row.each_char.all?(STAR_CHAR)
    allstar_rows << index
  end
end
puts allstar_rows.inspect

# Expand Galaxy Left and Right
allstar_cols = []
rows.first.each_char.each_with_index do |char,index|
  if rows.map {|row| row.each_char.to_a[index]}.all?(STAR_CHAR)
  allstar_cols << index
  end
end
puts allstar_cols.inspect
# rows.each do |row|
#   puts row
# end

galaxies = rows.each_with_index.flat_map {|l,x| l.each_char.to_a.each_with_index.map {|c,y| c == GALAXY_CHAR ? Galaxy.new(y,x) : nil }}.compact

# puts galaxies.inspect
puts galaxies.length

distance = 0

galaxies.each_with_index do |g1,index|
  ((index+1)..(galaxies.length-1)).to_a.each do |n2|
    g2 = galaxies[n2]
    s = (g2.x-g1.x).abs
    s += (g2.y-g1.y).abs
    puts "#{([g1.x,g2.x].min..[g1.x,g2.x].max).to_a.inspect} -> #{allstar_cols}: #{([g1.x,g2.x].min..[g1.x,g2.x].max).to_a.intersection(allstar_cols).length}"
    s += ([g1.x,g2.x].min..[g1.x,g2.x].max).to_a.intersection(allstar_cols).length * 999999
    s += ([g1.y,g2.y].min..[g1.y,g2.y].max).to_a.intersection(allstar_rows).length * 999999
    distance += s
  end
end

puts distance


# 1376851909674 too high
