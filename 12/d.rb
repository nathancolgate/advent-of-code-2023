OPERATIONAL_CHAR = '.'
DAMAGED_CHAR = '#'
UNKNOWN_CHAR = '?'

input = File.read(File.expand_path("./input.txt"))
rows = input.split("\n")

def process(string,sizes)
  list = string.each_char.to_a
  t_damaged = sizes.sum
  t_operational = list.length - t_damaged
  n_unknown = list.count {|x| x == UNKNOWN_CHAR}
  n_damaged = list.count {|x| x == DAMAGED_CHAR}
  n_operational = list.count {|x| x == OPERATIONAL_CHAR}
  delta_damaged = t_damaged - n_damaged
  delta_operational = t_operational - n_operational
  permutations = ("1"*n_unknown).to_i(2)
  z = 0
  (0..permutations).each do |p|
    q = p.to_s(2).rjust(n_unknown, "0").each_char.to_a
    next unless q.count {|r| r == "1"} == delta_damaged
    v = -1
    s = list.map {|t,i|
      if t == UNKNOWN_CHAR
        v += 1
        q[v] == "1" ? DAMAGED_CHAR : OPERATIONAL_CHAR
      else
        t
      end
    }
    z += 1 if s.join('').split('.').reject {|u| u.empty?}.map(&:length) == sizes
  end
  z
end

y = rows.map do |row|
  list_char = row.split(' ').first
  sizes = row.split(' ').last.split(',').map(&:to_i)
  process(list_char,sizes)
end
puts "Niether"
puts y.inspect

both = rows.map do |row|
  list_char = row.split(' ').first
  unless list_char[-1] == DAMAGED_CHAR
    list_char = "?"+list_char+"?"
  end
  sizes = row.split(' ').last.split(',').map(&:to_i)
  process(list_char,sizes)
end
# front = rows.map do |row|
#   list_char = "?"+row.split(' ').first
#   sizes = row.split(' ').last.split(',').map(&:to_i)
#   process(list_char,sizes)
# end

# back = rows.map do |row|
#   list_char = "?"+row.split(' ').first
#   sizes = row.split(' ').last.split(',').map(&:to_i)
#   process(list_char,sizes)
# end
puts "Both"
puts both.inspect
# puts "Front"
# puts front.inspect
# puts "Back"
# puts back.inspect
puts "Desired"
z = [1,8,1,2,5,15]
puts z.inspect

ed = y.each_with_index.map {|z,i| z * both[i]**4}
puts ed.sum

# 4168825837524 - Too low