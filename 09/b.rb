class Sequence
  def initialize(values)
    @values = values
  end
  def deltas
    @values.each_cons(2).map { |a,b| b-a }
  end
  def subsequence
    Sequence.new(deltas)
  end
  def prediction
    @values.uniq.length == 1 ? @values.first : @values.first - subsequence.prediction
  end
end

readings = []
input = File.read(File.expand_path("./input.txt"))
input.split("\n").each do |string|
  readings << Sequence.new(string.split(' ').map(&:to_i))
end
puts readings.map(&:prediction).sum