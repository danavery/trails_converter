require "csv"

input = CSV.read(ARGV[0], headers: true)
new_rows = []
fixed_headers = []

yes_no_fields = %w(parking drinkwater restrooms kiosk)

input.each do |row|
  row.each do |key, value|
    if key =~ /trail\d/i && !value.nil?
      row[key] = "Ohio & Erie Canal Towpath Trail" if value == "Towpath Trail"
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
  new_rows.push row
end

input.headers.each do |header|
  # put header name changes here, like 
  # header = 'parking' if header == 'parkinglot'
  fixed_headers.push header
end

new_csv = CSV.new($stdout, write_headers: true, headers: fixed_headers)
new_rows.each{ |row| new_csv << row }