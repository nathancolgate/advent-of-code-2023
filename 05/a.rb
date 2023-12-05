class Mapping
  def initialize(text)
    @options = text.split(' ').map(&:to_i)
  end
  def destination_range_start
    @options[0]
  end
  def destination_range_end
    destination_range_start+range_length-1
  end
  def destination_range
    (destination_range_start..destination_range_end)
  end
  def source_range_start
    @options[1]
  end
  def source_range_end
    source_range_start+range_length-1
  end
  def source_range
    (source_range_start..source_range_end)
  end
  def range_length
    @options[2]
  end
end

class Map
  def initialize(text)
    @text = text
  end

  def name
    @text.split("\n").first.gsub(' map:','')
  end

  def from
    name.split('-').first
  end

  def to
    name.split('-').last
  end

  def mappings
    @mappings ||= begin
      m = []
      @text.split("\n").drop(1).each do |x|
        m << Mapping.new(x)
      end
      m
    end
  end

  def output(input)
    mapping = mappings.detect {|m| m.source_range_start <= input && input <= m.source_range_end}
    if mapping
      input - mapping.source_range_start + mapping.destination_range_start
    else
      input
    end
  end
end

input = File.read(File.expand_path("./input.txt"))
map_texts = input.split("\n\n")
seeds = map_texts.shift.split(':').last.split(' ').map(&:to_i)
maps = []
map_texts.each do |map_text|
  maps << Map.new(map_text)
end

vals = seeds.map do |input|
  maps.each do |map|
    input = map.output(input)
  end
  input
end

puts vals.min