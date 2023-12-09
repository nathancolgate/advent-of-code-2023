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
# puts forks.inspect

iteration = 0
current_forks = forks.select { |f| f.id[2] == "A" }.map(&:id)

things = {}

iterations = current_forks.map do |current_fork|
  things[current_fork] = [current_fork]
  next_fork = current_fork
  # The assumption here is that we've gone all the way around
  # and are starting over
  loop do
    things[current_fork] << next_fork if next_fork[2] == "Z"
    puts "Current Fork: #{next_fork}"
    direction = directions[iteration%directions.length]
    puts "Direction: #{direction}"
    m = (direction == "R") ? :right : :left
    if forks.detect {|f| f.id == next_fork}.send(m) == next_fork
      raise "LOOP @ #{next_fork}"
    end
    next_fork = forks.detect {|f| f.id == next_fork}.send(m)
    puts "Next Fork: #{next_fork}"
    iteration += 1
    break if (next_fork == current_fork && iteration%directions.length == 0 )
  end
end

puts things.inspect
# puts iterations.reduce(1, :lcm)

# 9406354142688456507161311200 too high
# 2773342091100 too low
