class Tile
  PIPES = {
    "F" => [:bottom,:right],
    "7" => [:bottom,:left],
    "J" => [:top,:left],
    "L" => [:top,:right],
    "-" => [:left,:right],
    "|" => [:bottom,:top]
  }
  attr_accessor :x,:y,:visited,:string,:type
  def initialize(string,x,y)
    @string = string
    @x = x
    @y = y
    @type = :unknown
  end
  def next(direction_in)
    @type = :pipe
    case PIPES[@string].detect {|n| n != direction_in}
    when :top
      [@x,(@y-1),:bottom]
    when :bottom
      [@x,(@y+1),:top]
    when :left
      [(@x-1),@y,:right]
    when :right
      [(@x+1),@y,:left]
    end
  end
  def color
    case @type
    when :pipe
      :red
    when :unknown
      :blue
    when :nothing
      :green
    end
  end
end

require 'colorize'

input = File.read(File.expand_path("./input.txt"))
tiles = input.split("\n").each_with_index.map {|l,x| l.each_char.to_a.each_with_index.map {|c,y| Tile.new(c,y,x)}}
# puts pipes.inspect


# sample
# path1_x = 1
# path1_y = 2
# path1_direction = :left

# path2_x = 0
# path2_y = 3
# path2_direction = :top

# input
path1_x = 110
path1_y = 108
path1_direction = :top

path2_x = 110
path2_y = 106
path2_direction = :bottom

iteration = 1

until path1_x == path2_x && path1_y == path2_y do
  iteration += 1
  path1_x,path1_y,path1_direction = tiles[path1_y][path1_x].next(path1_direction)
  path2_x,path2_y,path2_direction = tiles[path2_y][path2_x].next(path2_direction)
end
puts tiles[0][139].inspect
tiles[0][139].type = :nothing
puts tiles[0][139].inspect

tiles.each_with_index do |row,y|
  row.each_with_index do |tile,x|
    if (tiles[y-1][x].is_a?(Tile) && tiles[y-1][x].type == :nothing ||
      tiles[y+1][x].is_a?(Tile) && tiles[y+1][x].type == :nothing ||
      tiles[y][x-1].is_a?(Tile) && tiles[y][x-1].type == :nothing ||
      tiles[y][x+1].is_a?(Tile) && tiles[y][x+1].type == :nothing) && tile.type == :unknown
      puts "#{y} #{x} #{tile.type}" if y == 1
      # tile.type = :nothing
    end
  end
end

tiles.each do |y|
  puts y.map {|t| t.string.send(t.color)}.join('')
end

puts iteration

