require 'csv'

def readHeaders(filename)
    file = CSV.read(Dir.getwd + "/" + filename)
    headers = file[0]
    return headers

end

def main()
    print "Enter the filename: "
    theFileName = gets.chomp()
    header = readHeaders(theFileName)
    print header
    print "\n"
end

main()