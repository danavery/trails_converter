require "csv"

input = CSV.read(ARGV[0], headers: true)
new_rows = []
fixed_headers = []

yes_no_fields = %w(accessible dogs roadbike hike mtnbike equestrian xcntryski BRIDLE SKIING MNTBIKE SURFACE)

input.each do |row|
  row.each do |key, value|
    # puts key
    if key =~ /trail\d/i && !value.nil?
      # value.sub!(/_.+$/, "")
      # CVNP
      row[key] = "Ohio & Erie Canal Towpath Trail" if value == "Towpath"
      row[key] = "Ohio & Erie Canal Towpath Trail" if value == "Ohio and Erie Canal Towpath Trail"
      # MPSSC
      row[key] = "Ohio & Erie Canal Towpath Trail" if value == "Towpath Trail"
    end
    if yes_no_fields.include?(key)
      firstchar = value[0].downcase
      if firstchar == "y" || firstchar == "t"
        value = "y"
      elsif firstchar == "n" || firstchar == "f"
        value = "n"
      end
      row[key] = value
    end
  end
  #CVNP
  row["length"] = row["MILES"] if row["MILES"]
  new_rows.push row
end

input.headers.each do |header|
  #CVNP
  header = 'equestrian' if header == 'BRIDLE'
  header = 'xcntryski' if header == 'SKIING'
  header = 'mtnbike' if header == 'MNTBIKE'
  header = 'trlsurface' if header == 'SURFACE'
  fixed_headers.push header
end

new_csv = CSV.new($stdout, write_headers: true, headers: fixed_headers) 
new_rows.each{|row| new_csv << row}
