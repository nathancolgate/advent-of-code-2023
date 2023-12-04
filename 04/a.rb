ScratchCard = Struct.new(:number, :winning_numbers, :my_numbers) do
  def matching_numbers
    (winning_numbers & my_numbers)
  end
  def matches
    matching_numbers.length
  end
  def points
    matches > 0 ? 2**(matches-1) : 0
  end
end

input = File.read(File.expand_path("./input.txt"))
cards = input.split("\n")

my_cards = []

cards.each do |card|
  my_cards << ScratchCard.new(
    card.split(":").first.gsub("Card ","").to_i,
    card.split(":").last.split("|").first.split(" ").map(&:to_i),
    card.split(":").last.split("|").last.split(" ").map(&:to_i)
  )
end

puts my_cards.map {|c| c.points}.sum

