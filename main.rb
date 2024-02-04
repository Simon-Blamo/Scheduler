require "./scheduler.rb"

def main()
    tempArr = getRoomsCSV()
    theFileNameRoom = tempArr[0]
    roomAttributes = tempArr[1]

    tempArr = getRoomsReservationCSV()
    theFileNameReservation = tempArr[0]
    reservationAttributes = tempArr[1]

    buildings = saveRoomDetails(theFileNameRoom, roomAttributes)
    buildings = saveRoomBooking(theFileNameReservation, buildings, reservationAttributes)

    userPrefences = getUserPrefences()
    outputCSV = schedule(buildings, userPrefences)
end

main()
