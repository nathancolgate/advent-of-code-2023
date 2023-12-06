input = File.read(File.expand_path("./input.txt"))
time = input.split("\n").first.split(':').last.split(' ').join('').to_i
distance = input.split("\n").last.split(':').last.split(' ').join('').to_i

travels = (0..time).to_a.select do |hold|
  time_remaining = time - hold
  speed = hold
  travel = time_remaining * speed
  # puts "Held for #{hold}, travelled at a speed of #{speed} for #{time_remaining} for a distance of #{travel} - #{travel > distance ? "WIN" : "no"}"
  travel > distance
end


puts travels.length
