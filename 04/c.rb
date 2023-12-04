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

  cards_counter = []
  my_cards.length.times do |i|
    cards_counter << [i + 1, 1]
  end
  cards_counter = cards_counter.to_h

  my_cards.each_with_index do |card, index|
    index += 1

    (1..card.match_count).each do |offset|
      cards_counter[index + offset] += cards_counter[index]
    end
  end

  puts cards_counter.map { |c| c[1] }.sum
}
puts time.real

# 2953818 -> too low
# 2954022 -> too low after adding my cards

