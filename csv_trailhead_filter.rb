require "csv"

CSV.open("./summit_trailheads.csv", "w") do |csv|
  csv << ["NAME", "TRAIL1", "TRAIL2", "TRAIL3", "WKT", "SOURCE"]
  CSV.foreach("./cvnp_trailheads.csv", headers: true) do |row|
    csv << [row["Comment"], row["Trail_Assoc_1"], row["Trail_Assoc_2"], row["Trail_Assoc_3"], row["WKT"], "CVNP"]
  end
  CSV.foreach("./mpssc_trailheads.csv", headers: true) do |row|
    csv << [row["NAME"], row["TRAIL1"], row["TRAIL2"], row["TRAIL3"], row["WKT"], row["SOURCE"]]
  end
end
