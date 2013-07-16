require "csv"

# combines trailhead CSV files into combined summit_trailheads.csv,
# with modifications for trail name consistency

CSV.open("./summit_trailheads.csv", "w") do |csv|
  csv << ["NAME", "TRAIL1", "TRAIL2", "TRAIL3", "WKT", "SOURCE"]
  
  CSV.foreach("./cvnp_trailheads.csv", headers: true) do |row|
    # correct each Trail_Assoc_[x] field
    (["Trail_Assoc_1", "Trail_Assoc_2", "Trail_Assoc_3"]).each do |trail|
      next if row[trail].nil?

      # CVNP trailhead file fixes
      row[trail] = row[trail].sub(/Ohio (&|and) Erie Canal Towpath$/, "Ohio & Erie Canal Towpath Trail")
      row[trail] = row[trail].sub(/Bike and Hike Trail/, "Bike & Hike Trail")
      row[trail] = row[trail].sub(/Indian Springs/, "Indian Spring")

    end
    csv << [row["Comment"], row["Trail_Assoc_1"], row["Trail_Assoc_2"], row["Trail_Assoc_3"], row["WKT"], "CVNP"]
  end

  CSV.foreach("./mpssc_trailheads.csv", headers: true) do |row|

    # MPSSC trailhead file fixes
    row["NAME"] = row["NAME"].gsub(/Indian Springs/, "Indian Spring")

    csv << [row["NAME"], row["TRAIL1"], row["TRAIL2"], row["TRAIL3"], row["WKT"], row["SOURCE"]]
  end
end
