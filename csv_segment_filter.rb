require "csv"

# combine trail segments CSV files into summit_trail_segments.csv

CSV.open("./summit_trailsegments.csv", "ab") do |csv|
  csv << ["NAME1", "NAME2", "NAME3", "LENGTH", "SOURCE", "STEWARD", "WKT"]
  CSV.foreach("./cvnp_trails.4326.csv", headers: true) do |row|
    csv << [row["NAME1"], row["NAME2"], row["NAME3"], row["SHAPE_Leng"], "CVNP", row["Maintained"], row["WKT"]]
  end

  CSV.foreach("./mpssc_trails.4326.csv", headers: true) do |row|
    csv << [row["NAME"], "", "", row["LENGTH"], "MPSSC", "MPSSC", row["WKT"]]
  end

  # CSV.foreach("./cvnp_oecc_trails.4326.csv", headers: true) do |row|
  #   csv << [row["NAME1"], row["NAME2"], row["NAME3"], row["SHAPE_LENGTH"], "CVNP", "OECC", row["WKT"]]
  # end
end
