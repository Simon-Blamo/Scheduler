require "./Scheduler.rb"
require "colorize"

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
    outputAttributes = roomAttributes
    outputAttributes.unshift("Time")
    outputAttributes.unshift("Date")
    outputAttributes.push("Purpose")
    outputCSV = schedule(userPreferences, buildings)
    tempArr = formatForOutputCSV(outputCSV, outputAttributes)
    arr = []
    for element in 0 .. tempArr.length-1
        if element == 2
            for el in 0 .. tempArr[element].length-1
                for e in 0 .. tempArr[element][el].length-1
                    arr.push(tempArr[element][el][e])

                end
            end
        elsif element == 3
            for el in 0 .. tempArr[element].length-1
                arr.push(tempArr[element][el])

            end
        else
            arr.push(tempArr[element])
        end
    end
    arr = sortTimes(arr)
    print "Here is your generated schedule:\n\n"
    for el in 0 .. arr.length-1
        if arr[el][arr[el].length-1] == "Opening Session"
            for e in 0 .. arr[el].length-1
                if e == 0
                    print arr[el][e].yellow
                else
                    print ", ".yellow
                    print arr[el][e].to_s.yellow
                end
            end
            print "\n"
        elsif arr[el][arr[el].length-1]  == "Group Work"
            for e in 0 .. arr[el].length-1
                if e == 0
                    print arr[el][e].blue
                else
                    print ", ".blue
                    print arr[el][e].to_s.blue
                end
            end
            print "\n"
        elsif arr[el][arr[el].length-1]  == "Meal"
            for e in 0 .. arr[el].length-1
                if e == 0
                    print arr[el][e].red
                else
                    print ", ".red
                    print arr[el][e].to_s.red
                end
            end
            print "\n"
        else
            for e in 0 .. arr[el].length-1
                if e == 0
                    print arr[el][e].green
                else
                    print ", ".green
                    print arr[el][e].to_s.green
                end
            end
            print "\n"
        end
    end
    print "\nWould you like to save the schedule as a CSV? Enter 'Y' for Yes or 'N' for No: "
    while true
        response = gets.chomp()
        if response.downcase == "y"
            print "\n"
            print "What would you like to name the file?: "
            name = gets.chomp()
            CSV.open(name, "w") do |csv|
                csv << outputAttributes
                for element in 0 .. arr.length-1
                    csv << arr[element]
                end
            end
            currDir = Dir.getwd
            print "\n\"" + name + "\" has been saved to " + currDir + "\n"
            exit
        elsif response.downcase == "n"
            exit
        else
            "Response not understood.\nIf you would like to save the schedule as a CSV, enter 'Y' for Yes or 'N' for No: "
        end
    end

end

main()
