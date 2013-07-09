require "csv"

# changes mpssc csv from "lat, lng" field to WKT
CSV.open("mpssc_trailheads.csv", "w") do |csv|
  csv << ["WKT", "NAME", "TRAIL1", "TRAIL2", "TRAIL3", "SOURCE"]
  CSV.foreach("mpssc_trailheads.csv.orig") do |row|
    lat_lng = row[0]
    p row[0]
    next if row[0] == "Lat Long"
    lat, lng = lat_lng.split(", ")
    row[0] = "POINT (#{lng} #{lat})" if row[0] !~ /Lat/
    csv << row
  end
end