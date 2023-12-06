input = File.read(File.expand_path("./input.txt"))
f=input.split("\n")
g=Proc {|x| x.split(':').last.split(' ').join('').to_i}
a=g.call(f[0])
e=g.call(f[1])
puts (0..a).to_a.select {|h|((a - h) * h) > e}.length