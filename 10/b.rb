class Pipe
  PIPES = {
    "F" => [:bottom,:right],
    "7" => [:bottom,:left],
    "J" => [:top,:left],
    "L" => [:top,:right],
    "-" => [:left,:right],
    "|" => [:bottom,:top]
  }
  attr_reader :x,:y,:visited,:string
  def initialize(string,x,y)
    @string = string
    @x = x
    @y = y
    @visited = false
  end
  def next(direction_in)
    @visited = true
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
    @visited ? :red : :blue
  end
end

require 'colorize'

input = File.read(File.expand_path("./input.txt"))
pipes = input.split("\n").each_with_index.map {|l,x| l.each_char.to_a.each_with_index.map {|c,y| Pipe.new(c,y,x)}}
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
  path1_x,path1_y,path1_direction = pipes[path1_y][path1_x].next(path1_direction)
  path2_x,path2_y,path2_direction = pipes[path2_y][path2_x].next(path2_direction)
 end

pipes.each do |y|
  puts y.map {|p| p.string.send(p.color)}.join('')
end

puts iteration

