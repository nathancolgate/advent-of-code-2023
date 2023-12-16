require 'benchmark'

time = Benchmark.measure {
def process(string)
  if string.include?('-')
    operation = :remove
    char = '-'
  else
    operation = :add
    char = '='
  end
  label = string.split(char).first
  focal_length = string.split(char).last.to_i
  current_value = 0
  label.each_byte do |byte|
    current_value = current_value+byte
    current_value = current_value*17
    current_value = current_value%256
  end
  [current_value,operation,focal_length,label]
end


input = File.read(File.expand_path("./input.txt"))
sets = input.split(",")
LIMIT = 256
boxes = Array.new(LIMIT)
LIMIT.times do |i|
  boxes[i] = {}
end

sets.each do |set|
  box_index,operation,focal_length,label = process(set)
  if operation == :remove
    boxes[box_index].delete(label)
  else
    boxes[box_index][label] = focal_length
  end
end

j = boxes.each_with_index.flat_map do |box,box_index|
  box.keys.each_with_index.map do |label,lense_index|
    (box_index+1)*(lense_index+1)*(box[label])
  end
end
puts j.sum
}
puts time.real