input = File.read(File.expand_path("./input.txt"))
times = input.split("\n").first.split(':').last.split(' ').map(&:to_i)
distances = input.split("\n").last.split(':').last.split(' ').map(&:to_i)
puts times.inspect
puts distances.inspect

a = times.each_with_index.map do |time,index|
  travels = (0..time).to_a.select do |hold|
    time_remaining = time - hold
    speed = hold
    travel = time_remaining * speed
    puts "Held for #{hold}, travelled at a speed of #{speed} for #{time_remaining} for a distance of #{travel}"
    travel > distances[index]
  end
end

puts a.map(&:length).inject(:*)
