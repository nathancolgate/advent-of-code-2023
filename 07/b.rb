class Hand
  MAP = {"A" => 14,"2" =>  2, "3" =>  3, "4" =>  4, "5" =>  5, "6" =>  6,"7" =>  7,"8" => 8,"9" => 9,"T" => 10,"J" => 0,"Q" => 12,"K" => 13}
  RANK = {
    five_of_a_kind: 7,
    four_of_a_kind: 6,
    full_house: 5,
    three_of_a_kind: 4,
    two_pair: 3,
    one_pair: 2,
    high_card: 1
  }
  attr_reader :bid, :card_string
  def initialize(string)
    @card_string = string.split(' ').first.strip
    @bid = string.split(' ').last.to_i
  end
  def cards
    @cards ||= @card_string.each_char.map{|c| MAP[c]}
  end
  def enhanced_cards
    @cards ||= enhanced_card_string.each_char.map{|c| MAP[c]}
  end
  def enhanced_card_string
    if @card_string.include?("J")
      s = @card_string.gsub("J","")
      s = s.each_char.group_by(&:to_s).transform_values(&:length)
    else
      @cards
    end
  end
  def card_counts
    @card_counts ||= enhanced_cards.group_by(&:to_i).transform_values(&:length)
  end
  def type
    if card_counts.values.max == 5
      :five_of_a_kind
    elsif card_counts.values.max == 4
      :four_of_a_kind
    elsif card_counts.values.max == 3 && card_counts.length == 2
      :full_house
    elsif card_counts.values.max == 3
      :three_of_a_kind
    elsif card_counts.values.max == 2 && card_counts.length == 3
      :two_pair
    elsif card_counts.values.max == 2
      :one_pair
    else
      :high_card
    end
  end

  def score
    (RANK[type] * 1000000000) +
     (cards[0]*(13**5)) +
     (cards[1]*(13**4)) +
     (cards[2]*(13**3)) +
     (cards[3]*(13**2)) +
     (cards[4]*(13**1))
  end
end
hands = []
input = File.read(File.expand_path("./sample.txt"))
input.split("\n").each do |hand_string|
  hands << Hand.new(hand_string)
end

hands.each do |h|
  puts h.enhanced_card_string.inspect
end

# hands.sort_by! {|h| h.score }
# totals = hands.each_with_index.map do |h,i|
#   puts "#{h.card_string} -> #{h.type} -> #{h.score}: #{h.bid} * #{i+1}"
#   h.bid * (i+1)
# end
# puts totals.sum
