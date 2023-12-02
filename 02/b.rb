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

powers = games_hash.map do |game_id,subsets|
  n_red = subsets.map {|s| s["red"].to_i}.max
  n_green = subsets.map {|s| s["green"].to_i}.max
  n_blue = subsets.map {|s| s["blue"].to_i}.max
  n_red * n_green * n_blue
end

puts powers.sum

