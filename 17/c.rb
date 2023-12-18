require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/dot'
require 'colorize'
MAX=12

class Block
  attr_reader :x, :y, :heat_loss, :identifier,:name
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
    @identifier = "a#{@x*200+@y}"
    @name = "#{@x}-#{@y}"
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
    if y >= 0 && y <= MAX && x >= 0 && x <= MAX
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
    ObjectSpace.each_object(Block).detect {|e| e.x == MAX && e.y == MAX }
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
          puts "#{m[y][x].identifier},#{m[y][x].name}"
        end
      end
      m
    end
  end

  def parse
    matrix.each do |line|
      line.each do |block|
        # First is Identifier. Second is heat loss.
        puts "#{block.identifier},#{block.n?.first},NORTH,#{block.n?.last}" if block.n?
        puts "#{block.identifier},#{block.e?.first},EAST,#{block.e?.last}" if block.e?
        puts "#{block.identifier},#{block.s?.first},SOUTH,#{block.s?.last}" if block.s?
        puts "#{block.identifier},#{block.w?.first},WEST,#{block.w?.last}" if block.w?
      end
    end
    graph.add_vertices *vertices
  end
end

map = Map.new('sample.txt')

