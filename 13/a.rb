input = File.read(File.expand_path("./input.txt"))
sets = input.split("\n\n")
puts "There are #{sets.length} sets"
t = 0
sets.each_with_index do |set,i|
  # Find the vertical reflection
  vr = nil
  rows = set.split("\n")
  rows.length.times do |r|
    a = rows[0..r].reverse
    b = rows[(r+1)..]
    length = [[a.length,b.length].min - 1,0].max
    if a[..length] == b[..length]
      t += (r+1)*100 
    end
  end
  # Find the horizontal reflections
  hr = nil
  colsa = set.split("\n").map {|r| r.each_char.to_a}
  cols = []
  colsa.first.length.times do |x|
    cols << colsa.map {|r| r[x]}.join('')
  end
  puts "Set #{i} has #{cols.length} cols"
  cols.length.times do |r|
    a = cols[0..r].reverse
    b = cols[(r+1)..]
    length = [[a.length,b.length].min - 1,0].max
    if a[..length] == b[..length]
      t += (r+1)
    end
  end
end

puts t