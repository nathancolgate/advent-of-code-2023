require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/dot'
require 'colorize'

class Block
  attr_reader :x, :y, :heat_loss, :identifier
  def initialize(x,y,heat_loss,map)
    @map = map
    @x = x
    @y = y
    @heat_loss = heat_loss.to_i
    @start = false
    @finish = false
    # if heat_loss == "S"
    #   @heat_loss = ("a".."z").to_a.index("a")
    #   @start = true
    # end
    # if heat_loss == "E"
    #   @heat_loss = ("a".."z").to_a.index("z")
    #   @finish = true
    # end
    @identifier = "#{@x}-#{@y}"
  end

  def n?
    check(@y-1,@x)
  end

  def e?
    check(@y,@x+1)
  end

  def s?
    check(@y+1,@x)
  end

  def w?
    check(@y,@x-1)
  end

  def check(y,x)
    if y >= 0 && y <= 12 && x >= 0 && x <= 12
      [@map.matrix[y][x].identifier,@map.matrix[y][x].heat_loss]
    end
  end
end

class Map
  attr_reader :cycles, :edge_weights
  def initialize(file)
    @file = file
    @edge_weights = {}
    parse
  end

  def finish
    ObjectSpace.each_object(Block).detect {|e| e.x == 12 && e.y == 12 }
  end

  def shortest_path(start_identifier)
    graph = RGL::DirectedAdjacencyGraph.new
    @edge_weights.each { |(intersection1, intersection2), w| graph.add_edge(intersection1, intersection2) }
    # graph.write_to_graphic_file('jpg')
    puts "EDGE WEIGHTS:"
    puts start_identifier
    puts finish.identifier
    puts @edge_weights.inspect
    graph.dijkstra_shortest_path(@edge_weights, start_identifier, finish.identifier)
  end

  def remove(s,f)
    puts "Removing #{s.inspect},#{f.inspect}"
    @edge_weights.delete([s,f])
    @edge_weights.delete([f,s])
  end

  def vertices
    @vertices ||= matrix.flat_map {|l| l.map(&:identifier) }
  end

  def graph
    RGL::DirectedAdjacencyGraph.new
  end

  def input
    File.read(File.expand_path("./#{@file}"))
  end

  def lines
    input.split("\n")
  end

  def matrix
    @matrix ||= begin
      m = []
      lines.each_with_index do |line,y|
        m[y] = []
        line.chars.each_with_index do |char,x|
          m[y][x] = Block.new(x,y,char,self)
        end
      end
      m
    end
  end

  def parse
    matrix.each do |line|
      line.each do |block|
        # First is Identifier. Second is heat loss.
        @edge_weights[[block.identifier,block.n?.first]] = block.n?.last if block.n?
        @edge_weights[[block.identifier,block.e?.first]] = block.e?.last if block.e?
        @edge_weights[[block.identifier,block.s?.first]] = block.s?.last if block.s?
        @edge_weights[[block.identifier,block.w?.first]] = block.w?.last if block.w?
      end
    end
    graph.add_vertices *vertices
  end
end

map = Map.new('sample.txt')
start_id = "0-0"
final_path = []
loop do
  puts "Starting at #{start_id}"
  if start_id == "12-12"
    final_path << start_id
    break 
  end
  shortest = map.shortest_path(start_id)
  puts shortest.inspect

  total = 0
  map.lines.each_with_index do |line,y|
    v = line.each_char.each_with_index.map do |char,x|
      b = ObjectSpace.each_object(Block).detect {|e| e.x == x && e.y == y }
      color = shortest.include?(b.identifier) ? :red : :white
      total += shortest.include?(b.identifier) ? b.heat_loss : 0
      char.send(color)
    end 
    puts v.join('')
  end
  puts total

  loop do
    distance = shortest.first == "0-0" ? 3 : 4
    same_row = shortest[0..(distance-1)].map {|p| p.split('-').first}.uniq.length == 1
    same_col = shortest[0..(distance-1)].map {|p| p.split('-').last}.uniq.length == 1
    if same_row || same_col
      puts " all same"
      map.remove(shortest[distance-1],shortest[distance])
      start_id = shortest[distance-1]
      (distance-1).times do
        puts "Adding #{shortest.first.inspect}"
        final_path << shortest.shift
      end
      break
    else
      puts 'good to go'
      puts "Adding #{shortest.first.inspect}"
      final_path << shortest.shift
    end
  end
end

puts '*'*88

total = 0
map.lines.each_with_index do |line,y|
  v = line.each_char.each_with_index.map do |char,x|
    b = ObjectSpace.each_object(Block).detect {|e| e.x == x && e.y == y }
    color = final_path.include?(b.identifier) ? :red : :white
    total += final_path.include?(b.identifier) ? b.heat_loss : 0
    char.send(color)
  end 
  puts v.join('')
end
puts total

puts final_path.inspect
r = final_path.map do |id|
  ObjectSpace.each_object(Block).detect {|b| b.identifier == id}.heat_loss
end
puts r.inspect
puts r.sum
