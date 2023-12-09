class ForkInTheRoad
  attr_reader :id, :left, :right
  def initialize(id,left,right)
    @id = id
    @left = left
    @right = right
  end
end

readings = []
input = File.read(File.expand_path("./input.txt"))
lines = input.split("\n")
directions = lines.shift.each_char.to_a
lines.shift
puts directions.inspect
forks = lines.map do |line|
  ForkInTheRoad.new(
    line.split('=').first.strip,
    line.split('=').last.split(',').first.gsub('(','').strip,
    line.split('=').last.split(',').last.gsub(')','').strip
  )
end
puts forks.inspect

iteration = 0
current_fork = "AAA"

until current_fork == "ZZZ" do
  puts "Current Fork: #{current_fork}"
  direction = directions[iteration%directions.length]
  puts "Direction: #{direction}"
  m = (direction == "R") ? :right : :left
  puts "Next Fork: #{forks.detect {|f| f.id == current_fork}.send(m)}"
  iteration += 1
  current_fork = forks.detect {|f| f.id == current_fork}.send(m)
 end

 puts iteration
