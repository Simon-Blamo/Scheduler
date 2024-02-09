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
    # buildings.each do |key, value|
    #     print key
    #     print "\n"
    #     print value
    #     print "\n"
    # end
    userPreferences = getUserPreferences()
    outputAttributes = roomAttributes
    outputAttributes.unshift("Time")
    outputAttributes.unshift("Date")
    outputAttributes.push("Purpose")
    outputCSV = schedule(userPreferences, buildings)
    arr = formatForOutputCSV(outputCSV, outputAttributes)
    print "Here is your generated schedule:\n\n"
    for el in 0 .. arr.length-1
        print arr[el]
        print "\n\n\n"
    end

    print "Would you like to save the schedule as a CSV? Enter 'Y' for Yes or 'N' for No: "
    while true
        response = gets.chomp()
        if response.downcase == "y"
            print "\n"
            print "What would you like to name the file?: "
            name = gets.chomp()
            CSV.open(name, "w") do |csv|
                csv << outputAttributes
                for el in 0 .. arr.length-1
                    if el == 2 or el == 3
                        for e in 0 .. arr[el].length-1
                            csv << arr[el][e]
                        end
                    else
                        csv << arr[el]
                    end
                end
            end
            exit
        elsif response.downcase == "n"
            exit
        else
            "Response not understood.\nIf you would like to save the schedule as a CSV, enter 'Y' for Yes or 'N' for No: "
        end
    end

end

main()
