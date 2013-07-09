require "csv"

CSV.open("./summit_trail_segments.csv", "ab") do |csv|
  csv << ["NAME1", "NAME2", "NAME3", "LENGTH", "SOURCE", "WKT"]
  CSV.foreach("./cvnp_trails.4326.csv", headers: true) do |row|
    csv << [row["NAME1"], row["NAME2"], row["NAME3"], row["SHAPE_Leng"], "CVNP", row["WKT"]]
  end

  CSV.foreach("./mpssc_trails.4326.csv", headers: true) do |row|
    csv << [row["NAME"], "", "", row["LENGTH"], "MPSSC", row["WKT"]]
  end
end
