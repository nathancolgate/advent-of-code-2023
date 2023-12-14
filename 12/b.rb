OPERATIONAL_CHAR = '.'
DAMAGED_CHAR = '#'
UNKNOWN_CHAR = '?'

input = File.read(File.expand_path("./sample.txt"))
rows = input.split("\n")

def count_of_ones(number)
  count = 0
  while number != 0
    count += number & 1
    number >>= 1
  end
  count
end

y = rows.map do |row|
  list_char = row.split(' ').first
  x = Array.new(5,list_char)
  list_char = x.join('?')
  list = list_char.each_char.to_a
  sizes = row.split(' ').last.split(',').map(&:to_i)
  sizes = sizes * 5
  puts '-'
  puts list_char.inspect
  puts sizes.inspect
  t_damaged = sizes.sum
  puts "There should be #{t_damaged} damaged springs"
  t_operational = list.length - t_damaged
  puts "There should be #{t_operational} operational springs"
  n_unknown = list.count {|x| x == UNKNOWN_CHAR}
  puts "There are #{n_unknown} unknown spots"
  n_damaged = list.count {|x| x == DAMAGED_CHAR}
  puts "There are #{n_damaged} damaged spots"
  n_operational = list.count {|x| x == OPERATIONAL_CHAR}
  puts "There are #{n_operational} operational spots"
  delta_damaged = t_damaged - n_damaged
  puts "We need to solve for #{delta_damaged} damaged springs"
  delta_operational = t_operational - n_operational
  puts "We need to solve for #{delta_operational} operational springs"
  if delta_damaged < delta_operational
    puts "It is easier to solve for the damaged springs"
  else
    puts "It is easier to solve for the operational springs"
  end
  permutations = ("1"*n_unknown).to_i(2)
  puts "There are #{permutations} permutations"
  # z = 0
  # (0..permutations).each do |p|
  #   next unless p.to_s(2).count('1') == delta_damaged
  #   q = p.to_s(2).rjust(n_unknown, "0").each_char.to_a
  #   v = -1
  #   s = list.map {|t,i|
  #     if t == UNKNOWN_CHAR
  #       v += 1
  #       q[v] == "1" ? DAMAGED_CHAR : OPERATIONAL_CHAR
  #     else
  #       t
  #     end
  #   }
  #   z += 1 if s.join('').split('.').reject {|u| u.empty?}.map(&:length) == sizes
  # end
  # puts z
  # z
end
puts y.sum