require 'benchmark'

ScratchCard = Struct.new(:number, :winning_numbers, :my_numbers, :n) do
  attr_reader :n
  def matching_numbers
    (winning_numbers & my_numbers)
  end
  def match_count
    matching_numbers.length
  end
  def copy
    # puts "COPY #{self[:n]}"
    self[:n] += 1
  end
end

input = File.read(File.expand_path("./input.txt"))
cards = input.split("\n")

my_cards = []

cards.each do |card|
  my_cards << ScratchCard.new(
    card.split(":").first.gsub("Card ","").to_i,
    card.split(":").last.split("|").first.split(" ").map(&:to_i),
    card.split(":").last.split("|").last.split(" ").map(&:to_i),
    1
  )
end

time = Benchmark.measure {
  my_cards.each_with_index do |c,index|
    c[:n].times do
      my_cards[(index+1)..(index+c.match_count)].map(&:copy)
    end
  end
}
puts time.real

puts my_cards.map {|c| c[:n]}.sum
# 2953818 -> too low
# 2954022 -> too low after adding my cards

