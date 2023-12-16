class Tile
  PIPES = {
    "." => {top: [:bottom], right: [:left], bottom: [:top], left: [:right]},
    "|" => {top: [:bottom], right: [:top,:bottom], bottom: [:top], left: [:top,:bottom]},
    "-" => {top: [:left,:right], right: [:left], bottom: [:left,:right], left: [:right]},
    "\\" => {top: [:right], right: [:top], bottom: [:left], left: [:bottom]},
    "/" => {top: [:left], right: [:bottom], bottom: [:right], left: [:top]},
  }
  attr_accessor :x,:y,:string
  def initialize(string,x,y)
    @string = string
    @x = x
    @y = y
    @visited_from = {top: false, right: false, bottom: false, left: false}
  end
  def energized?
    @visited_from.values.count(true) > 0
  end
  def to_s
    if ["|","-","\\","/"].include?(@string)
      @string
    elsif @visited_from.values.count(true) > 1
      @visited_from.values.count(true)
    else
      if @visited_from[:top]
        "v"
      elsif @visited_from[:bottom]
        "^"
      elsif @visited_from[:left]
        ">"
      elsif @visited_from[:right]
        "<"
      else
        "."
      end
    end
  end
  def instructions(direction_in)
    puts "Coming from: #{direction_in}"
    return [] if @visited_from[direction_in]
    @visited_from[direction_in] = true
    PIPES[@string][direction_in].map do |direction_out|
      puts "Going: #{direction_out}"
      case direction_out
      when :top
        [@x,(@y-1),:bottom]
      when :bottom
        [@x,(@y+1),:top]
      when :left
        [(@x-1),@y,:right]
      when :right
        puts [(@x+1),@y,:left].inspect
        [(@x+1),@y,:left]
      end
    end
  end
end

require 'colorize'

input = File.read(File.expand_path("./input.txt"))
tiles = input.split("\n").each_with_index.map {|l,x| l.each_char.to_a.each_with_index.map {|c,y| Tile.new(c,y+1,x+1)}}
BORDER_CHAR = "#"
tiles.each do |row|
  row.unshift(BORDER_CHAR)
  row.push(BORDER_CHAR)
end
tiles.unshift(Array.new(tiles.first.length,BORDER_CHAR))
tiles.push(Array.new(tiles.first.length,BORDER_CHAR))

start = [1,1,:left]

def parse(instructions,tiles)
  x = instructions[0]
  y = instructions[1]
  direction = instructions[2]
  tile = tiles[y][x]
  puts "Visisting #{x} #{y}"
  if tile.is_a?(Tile)
    puts "It's a tile"
    tile.instructions(direction).each do |sub_instructions|
      parse(sub_instructions,tiles)
    end
  end
end

parse(start,tiles)



tiles.each do |y|
  puts y.map {|p| p.to_s}.join('')
end

count = 0
tiles.each do |y|
  y.each do |x|
    if x.is_a?(Tile)
      if x.energized?
        count += 1
      end
    end
  end
end
puts count



