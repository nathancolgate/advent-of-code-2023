input = File.read(File.expand_path("./input.txt"))
games = input.split("\n")

games_hash = {}

games.each do |game|
  game_number = game.split(":").first.gsub("Game ","").to_i
  games_hash[game_number] = []
  game.split(":").last.split(";").each do |subset|
    s = {}
    subset.split(",").each do |di|
      s[di.match(/[a-z]+/)[0]] = di.match(/\d+/)[0].to_i
    end
    games_hash[game_number] << s
  end
end

max_red = 12
max_green = 13
max_blue = 14

total = 0

games_hash.each do |game_id,subsets| 
  results = subsets.map do |subset|
    subset["blue"].to_i <= max_blue && subset["green"].to_i <= max_green && subset["red"].to_i <= max_red
  end
  total += game_id if results.all?(true)
end
puts total