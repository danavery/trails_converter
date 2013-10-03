require "csv"

input = CSV.read(ARGV[0], headers: true)
new_rows = []
fixed_headers = []

input.each do |row|
  row.each do |key, value|
    if key =~ /trail\d/i && !value.nil?
      row[key] = "Ohio & Erie Canal Towpath Trail" if value == "Ohio and Erie Canal Towpath Trail"
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