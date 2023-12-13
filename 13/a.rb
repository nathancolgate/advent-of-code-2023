input = File.read(File.expand_path("./sample.txt"))
sets = input.split("\n\n")
puts "There are #{sets.length} sets"
sets.each_with_index do |set,i|
  # Find the vertical reflection
  vr = nil
  rows = set.split("\n")
  puts "Set #{i} has #{rows.length} rows"
  rows.length.times do |r|
    puts "#{rows[r]} <-> #{rows[r+1]}"
    vr = (r+1)*100 if rows[r] == rows[r+1]
  end
  # Find the horizontal reflections
  hr = nil
  colsa = set.split("\n").map {|r| r.each_char.to_a}
  cols = []
  colsa.first.length.times do |x|
    cols << colsa.map {|r| r[x]}.join('')
  end
  puts cols.inspect
  puts "Set #{i} has #{cols.length} cols"
  cols.length.times do |r|
    puts "#{cols[r]} <-> #{cols[r+1]}"
    hr = (r+1) if cols[r] == cols[r+1]
  end
  puts (vr*100)+hr
end