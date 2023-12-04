require 'benchmark'

time = Benchmark.measure {
  ScratchCard = Struct.new(:number, :winning_numbers, :my_numbers, :n) do
    attr_reader :n
    def matching_numbers
      (winning_numbers & my_numbers)
    end
    def match_count
      matching_numbers.length
    end
    def copy(x)
      # puts "COPY #{self[:n]}"
      self[:n] += x
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


  my_cards.each_with_index do |c,index|
    my_cards[(index+1)..(index+c.match_count)].map {|card| card.copy(c[:n])}
  end
  puts my_cards.map {|c| c[:n]}.sum
}
puts time.real

# 2953818 -> too low
# 2954022 -> too low after adding my cards

