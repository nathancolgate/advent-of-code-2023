def process(string)
  current_value = 0
  string.each_byte do |byte|
    current_value = current_value+byte
    current_value = current_value*17
    current_value = current_value%256
  end
  current_value
end

input = File.read(File.expand_path("./input.txt"))
sets = input.split(",")
puts sets.map {|s| process(s) }.sum

