require "./scheduler.rb"

# Time Complexity: O(n * m)
# Space Complexity: ???
# Does the work.
def main()
    tempArr = getRoomsCSV()
    theFileNameRoom = tempArr[0]
    roomAttributes = tempArr[1]

    tempArr = getRoomsReservationCSV()
    theFileNameReservation = tempArr[0]
    reservationAttributes = tempArr[1]

    buildings = saveRoomDetails(theFileNameRoom, roomAttributes)
    buildings = saveRoomBooking(theFileNameReservation, buildings, reservationAttributes)

    userPreferences = getUserPreferences()
    outputCSV = schedule(buildings, userPreferences)
end

main()
