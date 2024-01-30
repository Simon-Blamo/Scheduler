require 'csv'

CSV.foreach(("addresses.csv"), headers: true, col_sep: ",") do |row|
    puts row 
end 

def readerHeaders()