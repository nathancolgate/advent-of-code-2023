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
allstars = []
rows.each_with_index do |row,index|
  if row.each_char.all?(STAR_CHAR)
    allstars << index
  end
end
allstars.each_with_index do |allstar,index|
  rows.insert(allstar+index, STAR_CHAR*galaxy_width)
end
puts allstars.inspect

# Expand Galaxy Left and Right
allstars = []
rows.first.each_char.each_with_index do |char,index|
  if rows.map {|row| row.each_char.to_a[index]}.all?(STAR_CHAR)
    allstars << index
  end
end
allstars.each_with_index do |allstar,index|
  rows.map! do |row|
    row.each_char.to_a.insert(allstar+index,STAR_CHAR).join('')
  end
end
puts allstars.inspect
# rows.each do |row|
#   puts row
# end

galaxies = rows.each_with_index.flat_map {|l,x| l.each_char.to_a.each_with_index.map {|c,y| c == GALAXY_CHAR ? Galaxy.new(y,x) : nil }}.compact

puts galaxies.inspect
puts galaxies.length

distance = 0

galaxies.each_with_index do |g1,index|
  ((index+1)..(galaxies.length-1)).to_a.each do |n2|
    g2 = galaxies[n2]
    s = (g2.x-g1.x).abs
    s += (g2.y-g1.y).abs
    # puts "#{index+1} -> #{n2+1}: #{s}"
    distance += s
  end
end

puts distance
