input = File.read(File.expand_path("./input.txt"))
calibration_values = input.split("\n")
r = /\d{1}/

adjusted_values = calibration_values.map do |v|
  a = v.scan(r).first.to_s
  b = v.scan(r).last.to_s
  c = "#{a}#{b}".to_i
end

puts adjusted_values.sum
