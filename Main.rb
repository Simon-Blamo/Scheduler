require "./Scheduler.rb"

# Time Complexity: O(n * m)
# Space Complexity: ???
# Does the work.
def main()
    tempArr = getRoomsCSV()
    theFileNameRoom = tempArr[0]
    roomAttributes = tempArr[1]
    # print roomAttributes
    # print"\n"
    tempArr = getRoomsReservationCSV()
    theFileNameReservation = tempArr[0]
    reservationAttributes = tempArr[1]
    # print reservationAttributes
    # print"\n"
    buildings = saveRoomDetails(theFileNameRoom, roomAttributes)
    buildings = saveRoomBooking(theFileNameReservation, buildings, reservationAttributes)

    userPreferences = getUserPreferences()
    outputCSV = schedule(buildings, userPreferences)
end

main()
