require "csv"

input = CSV.read(ARGV[0], headers: true)
new_rows = []
fixed_headers = []

yes_no_fields = %w(accessible roadbike hike mtnbike equestrian xcntryski)

input.each do |row|
  row.each do |key, value|
    # puts key
    if key =~ /trail\d/ && !value.nil?
      value.sub!(/_.+$/, "")
      row[key] = "Ohio & Erie Canal Towpath Trail" if value == "Towpath"
    end
    if yes_no_fields.include?(key)
      firstchar = value[0].downcase
      if firstchar == "y" || firstchar == "t"
        row[key] = "y"
      elsif firstchar == "n" || firstchar == "f"
        row[key] = "n"
      end
    end
  end
  row["length"] = row["MILES"]
  new_rows.push row
end

input.headers.each do |header|
  header = 'xcntryski' if header == 'SKIING'
  header = 'mtnbike' if header == 'MNTBIKE'
  header = 'trlsurface' if header == 'SURFACE_1'
  fixed_headers.push header
end

new_csv = CSV.new($stdout, write_headers: true, headers: fixed_headers) 
new_rows.each{|row| new_csv << row}
