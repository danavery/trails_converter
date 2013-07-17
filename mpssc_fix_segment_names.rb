
# fix MPSSC segment CSV to match trail names in mpssc_traildata.csv

File.open(ARGV[0], "r").each do |line|
  line = line.gsub(/Ohio & Erie Canal To/, "Ohio & Erie Canal Towpath Trail")
  line = line.gsub(/Chuckery/, "Chuckery Trail")
  line = line.gsub(/Highbridge/, "Highbridge Trail")
  line = line.gsub(/Alder Pond Trail/, "Alder Trail")
  line = line.gsub(/Schumacher Valley/, "Schumacher Trail")
  # multiple Parcours
  line = line.gsub(/Valley Link/, "Valley Link Trail")
  # Freedom trail not in shapefile
  line = line.gsub(/Meadow Loop/, "Meadow Loop Trail")
  # multiple Meadow Trails
  # Cherry Lane Trail not in shapefile
  line = line.gsub(/Willow/, "Willow Trail")
  # "Walking?"
  # Cuyahoga Trail missing (CMP?)
  line = line.gsub(/Sugarbush/, "Sugarbush Trail")
  puts line
end

