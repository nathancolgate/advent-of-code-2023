class Tile
  CUBE_CHAR = "#"
  ROUND_CHAR = "O"
  EMPTY_CHAR = "."
  attr_accessor :x,:y,:string
  def initialize(string,x,y)
    @string = string
    @x = x
    @y = y
  end
  def is_a?(type)
    type == @string
  end
  def move(direction,tiles)
    return unless is_a?(ROUND_CHAR)
    # For now it's always up
    distance = 0
    puts '----'
    puts [@x,@y]
    puts (0..@y-1).to_a.reverse.inspect
    (0..@y-1).to_a.reverse.each do |row_index|
      puts row_index
      row = tiles[row_index]
      puts row[@x].is_a?(ROUND_CHAR)
      distance += 1 if row[@x].is_a?(EMPTY_CHAR)
      break if row[@x].is_a?(CUBE_CHAR)
    end
    puts "Distance: #{distance}"
    @y = @y - distance
  end
  def to_s
    @string
  end
  def weight(l)
    if is_a?(ROUND_CHAR)
      l - @y -1
    else
      0
    end
  end

end

input = File.read(File.expand_path("./input.txt"))
tiles = input.split("\n").each_with_index.map {|l,x| l.each_char.to_a.each_with_index.map {|c,y| Tile.new(c,y+1,x+1)}}
tiles.each_with_index do |row,index|
  row.unshift(Tile.new(Tile::CUBE_CHAR,0,index))
  row.push(Tile.new(Tile::CUBE_CHAR,row.length,index))
end
tiles.unshift([])
tiles.push([])
tiles[1].each_with_index do |x,i|
  tiles.first << Tile.new(Tile::CUBE_CHAR,i,0)
  tiles.last << Tile.new(Tile::CUBE_CHAR,i,tiles[1].length-1)
end
# tiles.push(Array.new(tiles.first.length,BORDER_CHAR))

# start = [1,1,:left]

# def parse(instructions,tiles)
#   x = instructions[0]
#   y = instructions[1]
#   direction = instructions[2]
#   tile = tiles[y][x]
#   puts "Visisting #{x} #{y}"
#   if tile.is_a?(Tile)
#     puts "It's a tile"
#     tile.instructions(direction).each do |sub_instructions|
#       parse(sub_instructions,tiles)
#     end
#   end
# end

# parse(start,tiles)

tiles.each do |y|
  y.each do |tile|
    tile.move(:up,tiles)
  end
end

tiles.each do |y|
  puts y.map {|z| z.weight(tiles.length)}.inspect
end

j = tiles.flat_map do |y|
  y.map {|z| z.weight(tiles.length)}
end

puts j.sum