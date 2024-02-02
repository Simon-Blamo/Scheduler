require 'csv'

# Error checking function. Checks if filename given is valid.
def fileNameGivenIsValid(fileName)
    if fileName.downcase == "exit"
        return 0
    end
    begin
        CSV.read(Dir.getwd + "/" + fileName)
    rescue
        return -1
    end
end

# Read Columns of CSV
def readAttributes(fileName)
    file = CSV.read(Dir.getwd + "/" + fileName)
    attributes = file[0]
    return attributes
end

# Input prompt function to Read the first CSV given.
def GetRoomsCSV()
    print "Enter the filename of the Rooms CSV (Enter EXIT to quit): "
    while true
        theFileNameRoom = gets.chomp()
        isValid = fileNameGivenIsValid(theFileNameRooms)
        if isValid == -1
            print "File \"" + theFileNameRoom + "\" found. Please make sure the file your entering is located within the same directory.\n\n"
            print "Enter the filename (Enter EXIT to quit): "
        elsif isValid == 0
            exit
        else
            break
        end
    end
    roomAttributes = readAttributes(theFileNameRoom)
    return [theFileNameRoom, roomAttributes]
end

# Input prompt function to read the second CSV given.
def GetRoomsReservationCSV()
    print "Enter the filename of the Reserved Rooms CSV (Enter EXIT to quit): "
    while true
        theFileNameReservation = gets.chomp()
        isValid = fileNameGivenIsValid(theFileNameRoomReservation)
        if isValid == -1
            print "File \"" + theFileNameRoomReservation + "\" found. Please make sure the file your entering is located within the same directory.\n\n"
            print "Enter the filename (Enter EXIT to quit): "
        elsif isValid == 0
            exit
        else
            break
        end
    end
    reservationAttributes = readAttributes(theFileNameReservation)
    return [theFileNameReservation, reservationAttributes]
end

# Reads the Room details, returns a hashmap with the key-value pair with the keys being the building name,
# and the value being ANOTHER hashmap with the key-value pair with its keys being the room number, and the
# values of that being yet ANOTHER hashmap with the key-value pair with its keys being the attribute(column), and the
# values being the value for that respective attribute for that row.
def saveRoomDetails(fileName, attributes)
    buildingsHash = {}
    file = CSV.read(Dir.getwd + "/" + fileName)
    for row in 0 .. file.length-1
        roomDetails = {}
        building = file[row][0]
        room = file[row][1]
        for attr in 2 .. file[row].length-1
            roomDetails[attributes[attr]] = file[row][attr]
        end
        buildingsHash[building] = {room => roomDetails}
    end
    return buildingsHash
end

# To be implemented.
def saveRoomBooking(buildings, attributes)
end


# Main Function.
def main()
    tempArr = GetRoomsCSV()
    theFileNameRoom = tempArr[0]
    roomAttributes = tempArr[1]

    tempArr = GetRoomsReservationCSV()
    theFileNameReservation = tempArr[0]
    reservationAttributes = tempArr[1]
    #buildingDetails = getBuildingsDetails(theFileNameRoom, roomAttributes)
end

main()
