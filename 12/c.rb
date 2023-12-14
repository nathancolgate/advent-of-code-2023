OPERATIONAL_CHAR = '.'
DAMAGED_CHAR = '#'
UNKNOWN_CHAR = '?'
CURRENT_ROW = 3
# TODO
# 1 - All ones
# 2 - Too many permutations
# 5 - No step forward

input = File.read(File.expand_path("./sample.txt"))
rows = input.split("\n")

def help(string,target)
  permutations = ("1"*string.length).to_i(2)
  z = 0
  puts "Permutations: #{permutations}"
  return 999 if permutations > 9999
  (0..permutations).each do |p|
    q = p.to_s(2).rjust(string.length, "0").each_char.to_a
    q.count {|r| r == "1"}
    # next unless q.count {|r| r == "1"} == target.sum
    ded = q.join('').split('0').reject {|u| u.empty?}.map(&:length)
    next unless ded == target.first(ded.length)
    z += 1 
  end
  z
end

rows = [rows[CURRENT_ROW]]

ff = rows.map do |row|
  v = 0
  list_char = row.split(' ').first
  x = Array.new(5,list_char)
  list_char = x.join('?')
  list = list_char.each_char.to_a
  puts list_char
  sizes = row.split(' ').last.split(',').map(&:to_i)
  sizes = sizes * 5
  t_damaged = sizes.sum
  t_operational = list.length - t_damaged
  n_unknown = list.count {|x| x == UNKNOWN_CHAR}
  n_damaged = list.count {|x| x == DAMAGED_CHAR}
  n_operational = list.count {|x| x == OPERATIONAL_CHAR}
  delta_damaged = t_damaged - n_damaged
  delta_operational = t_operational - n_operational
  permutations = ("1"*n_unknown).to_i(2)
  a = list_char.split('.').reject {|u| u.empty?}
  if a.length == 1
    a = a.first.chars.chunk_while { |a, b| a == b }.map(&:join)
  end

  10.times do
    longest = sizes.max
    if sizes.count(longest) == a.map(&:length).count(longest)
      puts "Reduce by removing spaces that are the same length as the longest string of damaged springs"
      sizes = sizes.select {|b| b != longest}
      a = a.select {|b| b.length != longest}
    end
  end
  10.times do
    longest = sizes.max
    if sizes.count(longest) == a.count {|b| b.count("#") == longest}
      puts "Reduce by reducing spaces that contain the longest string of damaged springs (#{longest})"
      sizes = sizes.select {|b| b != longest}
      a = a.map {|b| b.gsub(/\??\#{#{longest}}\??/,'')}.reject {|u| u.empty?}
    end
  end
  10.times do
    longest = sizes.max
    if sizes.count(longest) == a.map(&:length).count(longest)
      puts "Reduce by removing spaces that are the same length as the longest string of damaged springs"
      sizes = sizes.select {|b| b != longest}
      a = a.select {|b| b.length != longest}
    end
  end
  if a.first.length < sizes.first
    puts "Reduce because it can't go in the first slot"
    a = a.drop(1)
  end
  if sizes.length == a.length
    puts "Shortcut solve 1:1"
    c = sizes.each_with_index.map {|s,i| a[i].length - s + 1}
    short = c.inject(:*)
    puts "Shortcut: #{short}"
    v = short
  end
  if a.uniq.length == 1 && sizes.length%a.length == 0
    puts "Shortcut solve similar permutations"
    string = a.first
    targets = sizes.first(sizes.length/a.length)
    # z = help(rr.length,tt.sum,rr.each_char.to_a,tt)
    z = help(string,targets)
    short = z**(sizes.length/a.length)
    puts "Shortcut: #{short}"
    v = short
  end
  puts sizes.inspect
  puts a.inspect
  a.each do |z|
    puts help(z,sizes)
  end
  v
end

puts "Hi"
puts ff.inspect