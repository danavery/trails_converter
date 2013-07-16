
# fix MPSSC segment CSV to match trail names in mpssc_traildata.csv

File.open("mpssc_trails.4326.short_names.csv", "r").each do |line|
  line = line.gsub(/Ohio & Erie Canal To/, "Ohio & Erie Canal Towpath Trail")
  line = line.gsub(/Chippewa Trail/, "Chippewa Creek Trail")
  line = line.gsub(/Adam Run/)
  puts line
end

