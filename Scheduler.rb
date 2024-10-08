require './HandleConflicts.rb'
require './UserPreferences.rb'




# Time Complexity: O(n)
# Space Complexity: O(1)
# Checks if timeInput given by user is in the PM or not.
def inPM(s)
    return s.downcase == "pm"
end

# Time Complexity: O(1)
# Space Complexity: O(1)
# Convert a String Array to a Date object.
def convertStringArrToDate(arr)
    year = arr[0].to_i
    month = arr[1].to_i
    day = arr[2].to_i
    if ((year != 2024) or ((day < 1) or (day > 31)) or ((month < 1) or (month > 12)))
        return -1
    end
    return Date.new(year, month, day)
end

# Time Complexity: O(n)
# # Space Complexity: O(1)
# Converts a String Array to a Time object.
def convertStringArrToTime(year, month, day, arr)
    if inPM(arr[1]) == true
        hours = (arr[0].split(":")[0].to_i + 12)
        hours = hours == 24 ? 12 : hours
        minutes = arr[0].split(":")[1].to_i
        time = Time.new(year.to_i, month.to_i, day.to_i, hours, minutes, 0)
    else
        hours = (arr[0].split(":")[0].to_i)
        hours = hours == 12 ? 0 : hours
        minutes = arr[0].split(":")[1].to_i
        time = Time.new(year.to_i, month.to_i, day.to_i, hours, minutes, 0,)
    end
    return time
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Converts a String Array to a Time object (Modified for the duration attribute).
def convertStringArrToTimeDuration(startTime, arr)
    time = startTime
    time += (arr[0].to_i * 60 * 60)
    time += (arr[1].to_i * 60)
    return time
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Read Columns of CSV
def readAttributes(fileName)
    file = CSV.read(Dir.getwd + "/" + fileName)
    attributes = file[0]
    return attributes
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Input prompt function to Read the first CSV given.
def getRoomsCSV()
    print "Enter the filename of the Rooms CSV (Enter EXIT to quit): "
    while true
        theFileNameRoom = gets.chomp()
        isValid = fileNameGivenIsValid(theFileNameRoom)
        if isValid == -1
            print "File \"" + theFileNameRoom + "\" found. Please make sure the file your entering is located within the same directory.\n\n"
            print "Enter the filename of the Rooms CSV (Enter EXIT to quit): "
        elsif isValid == 0
            exit
        else
            break
        end
    end
    roomAttributes = readAttributes(theFileNameRoom)
    return [theFileNameRoom, roomAttributes]
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Input prompt function to read the second CSV given.
def getRoomsReservationCSV()
    print "Enter the filename of the Reserved Rooms CSV (Enter EXIT to quit): "
    while true
        theFileNameReservation = gets.chomp()
        isValid = fileNameGivenIsValid(theFileNameReservation)
        if isValid == -1
            print "File \"" + theFileNameReservation + "\" found. Please make sure the file your entering is located within the same directory.\n\n"
            print "Enter the filename of the Reserved Rooms CSV (Enter EXIT to quit): "
        elsif isValid == 0
            exit
        else
            break
        end
    end
    reservationAttributes = readAttributes(theFileNameReservation)
    return [theFileNameReservation, reservationAttributes]
end

# Time Complexity: ??? where n is the number of rows in the files, and m is the number of attributes.
# Space Complexity: O(n * m)
# Reads the Room details, returns a hashmap with the key-value pair with the keys being the building name,
# and the value being ANOTHER hashmap with the key-value pair with its keys being the room number, and the
# values of that being yet ANOTHER hashmap with the key-value pair with its keys being the attribute(column), and the
# values being the value for that respective attribute for that row.
def saveRoomDetails(fileName, attributes)
    buildingsHash = {}
    file = CSV.read(Dir.getwd + "/" + fileName)
    for row in 1 .. file.length-1
        roomDetails = {}
        building = file[row][0]
        room = file[row][1]
        if validRoomValue(room) == false
            results = handleConflict1(room, "Room", file[row], 1)
            if results == 0
                value = nil
                break
            else
                file[row] = results
                value = file[row][attr]
            end
        end
        for attr in 2 .. file[row].length-1
            value = file[row][attr]
            if attributes[attr] == "Capacity"
                if validCapacityValue(value) == false
                    results = handleConflict1(value, attributes[attr], file[row], attr)
                    if results == 0
                        value = nil
                        break
                    else
                        file[row] = results
                        value = file[row][attr]
                    end
                end
                value = value.to_i
            elsif attributes[attr] == "Food Allowed"
                if validFoodAllowedValue(value) == false
                    results = handleConflict1(value, attributes[attr], file[row], attr)
                    if results == 0
                        value = nil
                        break
                    else
                        file[row] = results
                        value = file[row][attr]
                    end
                end
            elsif attributes[attr] == "Computers Available"
                if validComputersAvailableValue(value) == false
                    results = handleConflict1(value, attributes[attr], file[row], attr)
                    if results == 0
                        value = nil
                        break
                    else
                        file[row] = results
                        value = file[row][attr]
                    end
                end
            elsif attributes[attr] == "Seating Type"
                if validSeatingTypeValue(value) == false
                    results = handleConflict1(value, attributes[attr], file[row], attr)
                    if results == 0
                        value = nil
                        break
                    else
                        file[row] = results
                        value = file[row][attr]
                    end
                end
            end
            roomDetails[attributes[attr]] = value
        end

        if buildingsHash.has_key?(building) == false
            if value == nil
                buildingsHash.delete(room)
            else
                buildingsHash[building] = {room => roomDetails}
            end

        else
            if value == nil
                buildingsHash.delete(room)
            else
                buildingsHash[building][room] = roomDetails
            end
        end

    end
    return buildingsHash
end

# Time Complexity: O(n * m) where n is the number of rows in the files, and m is the number of attributes.
# Space Complexity: O(n * m)
# Reads the reservation details, and updates the building hashmap.
def saveRoomBooking(fileName, buildingsHash, attributes)
    file = CSV.read(Dir.getwd + "/" + fileName)
    for row in 1 .. file.length-1
        building = file[row][0]
        room = file[row][1]
        begin
            roomDetails = buildingsHash[building][room]
        rescue
            next

        end
        year = ""
        month = ""
        day = ""
        pendingTimeAddition = []
        for attr in 2 .. file[row].length-1
            value = file[row][attr]
            if attributes[attr] == "Date"
                dateArray = value.split("-")
                year = dateArray[0]
                month = dateArray[1]
                day = dateArray[2]
                date = convertStringArrToDate(dateArray)
                if date == -1
                    roomDetails = -1
                    break
                end

                begin
                    roomDetails[attributes[attr]] = date
                rescue
                    roomDetails = -1
                    break
                end
            elsif attributes[attr] == "Time" or attributes[attr] == "Duration"
                if attributes[attr] == "Time"
                    if roomDetails.has_key?("timeSlotArray") == false
                        roomDetails["timeSlotArray"] = []
                    end
                    timeArray = value.split(" ")
                    roomDetails[attributes[attr]] = convertStringArrToTime(year, month, day, timeArray)
                    pendingTimeAddition.push(convertStringArrToTime(year, month, day, timeArray))
                    if timeSlotIsValid(roomDetails["timeSlotArray"], pendingTimeAddition[0]) == false
                        roomDetails = -1
                        break
                    end
                else
                    eventEnd = convertStringArrToTimeDuration(pendingTimeAddition[0], value.split(":"))
                    roomDetails[attributes[attr]] = eventEnd
                    if timeSlotIsValid(roomDetails["timeSlotArray"], eventEnd) == false
                        roomDetails = -1
                        break
                    end
                    pendingTimeAddition.push(eventEnd)
                end
            else
                roomDetails[attributes[attr]] = value
            end
        end
        if roomDetails != -1
            roomDetails["timeSlotArray"].push(pendingTimeAddition)
            buildingsHash[building][room] = roomDetails
        else
            buildingsHash[building].delete(room)
        end
    end
    return buildingsHash
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Function to get user's desired preferences for their upcoming event.
def getUserPreferences()
    print "Enter the desired date of your event (yyyy-mm-dd Format): "
    while true
        date = gets.chomp()
        isValid = dateGivenIsValid(date)
        if isValid == -1
            print "Date, \"" + date + "\", not valid.\n\n"
            print "Enter the desired date of your event (yyyy-mm-dd Format): "
        else
            date = isValid
            break
        end
    end
    print "\n\n"
    print "Enter the desired start time of your event (e.g., 1:00 PM): "
    while true
        startTime = gets.chomp()
        isValid = startTimeGivenIsValid(date, startTime)
        if isValid == -1
            print "Start time, \"" + startTime + "\", not valid.\n\n"
            print "Enter the desired start time of your event (e.g., 1:00 PM): "
        else
            startTime = isValid
            break
        end
    end
    print "\n\n"
    print "Enter the duration of your event (e.g., 2:20): "
    while true
        durationTime = gets.chomp()
        isValid = durationTimeGivenIsValid(startTime, durationTime)
        if isValid == -1
            print "Duration time, \"" + durationTime + "\", not valid.\n\n"
            print "Enter the duration of your event (e.g., 2:20): "
        else
            durationTime = isValid[0]
            duration2 = isValid[1]
            break
        end
    end
    print "\n\n"
    print "Enter the expected number of attendees (e.g., 25): "
    while true
        attendees = gets.chomp()
        isValid = valueGivenIsValidNumeric(attendees)
        if isValid == -1
            print "Attendess number, " + attendees + "\", not valid.\n\n"
            print "Enter the expected number of attendees (e.g., 25): "
        else
            attendees = isValid
            break
        end
    end
    preferences = UserPreferences.new(date, startTime, durationTime, duration2, attendees)
    return preferences
end

# Time Complexity: O(1)
# Space Complexity: O(?)
# Properly breaks up event based on the Date/Start Time/Duration given.
def breakUpEvent(duration, startTime)
    if duration[0].to_i * 60  < 300
        return nil
    end

    openSeshStartTime = startTime
    openSeshEndTime = (openSeshStartTime + (60 * 60))

    mealEventsNeeded = (duration[0].to_i)/6.0
    if mealEventsNeeded <= 1.0
        hackStartTime = openSeshEndTime
        hackEndTime = hackStartTime + ((duration[0].to_i - 4) + (60 * 60))
        closeSeshStartTime = hackEndTime
        closeSeshEndTime = closeSeshStartTime + ((3) + (60 * 60))
        return {
            openingSessionTime: [openSeshStartTime, openSeshEndTime],
            hackTimes: [hackStartTime, hackEndTime],
            closingSessionTime: [closeSeshStartTime, closeSeshEndTime],
        }
    else
        timeAllocatedForOtherActivities = (duration[0].to_i) - 4
        mealEventsToAccountFor = mealEventsNeeded.floor()
        timeAllocatedForOtherActivities -= mealEventsToAccountFor
        hackSessionDurations = (timeAllocatedForOtherActivities.to_f / mealEventsToAccountFor).ceil()
        numberOfHackSessionsToAccountFor = (timeAllocatedForOtherActivities.to_f / hackSessionDurations).ceil()
        hackTimesArr = []
        mealTimesArr = []
        loopHackStartTime = openSeshEndTime
        finalEndTime = nil
        while (numberOfHackSessionsToAccountFor != 0) or (mealEventsToAccountFor != 0)
            if  numberOfHackSessionsToAccountFor != 0
                if timeAllocatedForOtherActivities < hackSessionDurations
                    hackSessionDurations = timeAllocatedForOtherActivities
                end
                tempArr = []
                tempArr.push(loopHackStartTime)
                loopHackEndTime =  loopHackStartTime += (hackSessionDurations * (60 * 60))
                tempArr.push(loopHackEndTime)
                numberOfHackSessionsToAccountFor -= 1
                hackTimesArr.push(tempArr)
                tempArr = nil
                finalEndTime = loopHackEndTime
                timeAllocatedForOtherActivities -= hackSessionDurations
            end
            if mealEventsToAccountFor != 0
                tempArr = []
                loopMealStartTime = loopHackEndTime
                tempArr.push(loopMealStartTime)
                loopMealEndTime = loopMealStartTime + (60 * 60)
                tempArr.push(loopMealEndTime)
                mealEventsToAccountFor -= 1
                mealTimesArr.push(tempArr)
                tempArr = nil
                loopHackStartTime = loopMealEndTime
                finalEndTime = loopMealEndTime
            end
        end

        closeSeshStartTime = finalEndTime
        closeSeshEndTime = closeSeshStartTime + (3 * (60 * 60))

        return {
            openingSessionTime: [openSeshStartTime, openSeshEndTime],
            closingSessionTime: [closeSeshStartTime, closeSeshEndTime],
            mealTimes: mealTimesArr,
            hackTimes: hackTimesArr
        }
    end
end

# Time Complexity: O(n * m) where n is the number of buildings and m is the number of rooms.
# Space Complexity: O(?)
# Find a room that can fit all attendees.
def findRoomForAll(buildings, totalAttendees, sessionArray, eventType)
    buildings.each do |building, rooms|
        rooms.each do |room, details|
            tsArr = details["timeSlotArray"]
            return [building, room, details, [sessionArray[0], sessionArray[1]], eventType] if details["Capacity"] >= totalAttendees and ((timeSlotIsValid(tsArr, sessionArray[0]) == true) and (timeSlotIsValid(tsArr, sessionArray[1]) == true))
        end
    end
    return nil
end

# Time Complexity: O(n * m * l) where n is the number of buildings, m is the number of rooms, and l is the length of the arrOfMealTimes array.
# Space Complexity: O(?)
# Finds a room that can fits the meal room constraints.
def findMealRooms(buildings, mealAttendees, arrOfMealTimes, eventType)
    arrayOfMealRooms = []
    buildings.each do |building, rooms|
        rooms.each do |room, details|
            next unless details["Food Allowed"].downcase == "yes"
            length = arrayOfMealRooms.length
            for times in 0 .. arrOfMealTimes.length - 1
                tsArr = details["timeSlotArray"]
                arrayOfMealRooms.push([building, room, details, [arrOfMealTimes[times][0], arrOfMealTimes[times][1]], eventType]) if details["Capacity"] >= mealAttendees and ((timeSlotIsValid(tsArr, arrOfMealTimes[times][0]) == true) and (timeSlotIsValid(tsArr, arrOfMealTimes[times][1]) == true))
                if arrayOfMealRooms.length > length
                    arrOfMealTimes.shift
                    break
                end
            end
            if arrayOfMealRooms == length
                return nil
            else
                return arrayOfMealRooms if arrOfMealTimes.length == 0
            end
        end
    end
    return nil
end

# Time Complexity: O(n * m * l) where n is the number of buildings, m is the number of rooms, and l is the length of the arrOfHackTimes array.
# Space Complexity: O(?)
# Find a room where participants without computers can hack in.
def findHackRooms(buildings, computersNeeded, arrOfHackTimes, eventType, areThereMeals)
    if areThereMeals == true
        arrayOfHackRooms = []
        for el in 0 .. arrOfHackTimes.length-1
            buildings.each do |building, rooms|
                currentCapacity = 0
                validRooms = []
                roomsFound = false
                rooms.each do |room, details|
                    next unless details["Computers Available"].downcase == "yes"
                    tsArr = details["timeSlotArray"]
                    next unless ((timeSlotIsValid(tsArr, arrOfHackTimes[el][0]) == true) and (timeSlotIsValid(tsArr, arrOfHackTimes[el][1]) == true))
                    currentCapacity += details["Capacity"]
                    validRooms.push([building, room, details, [arrOfHackTimes[el][0], arrOfHackTimes[el][1]], eventType])
                    if currentCapacity >= computersNeeded
                        arrayOfHackRooms.push(validRooms)
                        roomsFound = true
                        break
                    end
                end
                break if roomsFound == true
            end
        end
        if arrayOfHackRooms.length == arrOfHackTimes.length
            return arrayOfHackRooms
        end
        return nil
    else
        arrayOfHackRooms = []
        buildings.each do |building, rooms|
            currentCapacity = 0
            validRooms = []
            roomsFound = false
            rooms.each do |room, details|
                next unless details["Computers Available"].downcase == "yes"
                tsArr = details["timeSlotArray"]
                next unless ((timeSlotIsValid(tsArr, arrOfHackTimes[0]) == true) and (timeSlotIsValid(tsArr, arrOfHackTimes[1]) == true))
                currentCapacity += details["Capacity"]
                validRooms.push([building, room, details, [arrOfHackTimes[0], arrOfHackTimes[1]], eventType])
                if currentCapacity >= computersNeeded
                    arrayOfHackRooms.push(validRooms)
                    roomsFound = true
                    break
                end
            end
            break if roomsFound == true
        end
        if arrayOfHackRooms.length == arrOfHackTimes.length
            return arrayOfHackRooms
        end
    end
end

# Time Complexity: O(n * m * l) where n is the number of buildings, m is the number of rooms, and l is the length of the arrOfMealTimes/arrOfHackTimes array.
# Space Complexity: O(?)
# Plans the event based on the user preferences.
def schedule(userPreferences, buildings)
    totalAttendees = userPreferences.getAttendees
    mealAttendees = (totalAttendees * 0.6).ceil
    computersNeeded = (totalAttendees * 0.1).ceil

    eventType = [
        "Opening Session",
        "Group Work",
        "Meal",
        "Closing Session",
    ]

    timeScheduleForEvent = breakUpEvent(userPreferences.getDuration2, userPreferences.getStartTime)
    if timeScheduleForEvent == nil
        print "Cannot generate schedule!\n"
        exit
    end

    openingSeshTimeArr = timeScheduleForEvent[:openingSessionTime]
    closingSeshTimeArr = timeScheduleForEvent[:closingSessionTime]
    hackTimesArr = timeScheduleForEvent[:hackTimes]

    openingRoomDetailArr = findRoomForAll(buildings, totalAttendees, openingSeshTimeArr, eventType[0])
    if openingRoomDetailArr == nil
        print "Cannot generate schedule! No room matches opening room constraints!\n"
        exit
    end


    closingRoomDetailArr = findRoomForAll(buildings, totalAttendees, closingSeshTimeArr, eventType[3])
    if closingRoomDetailArr == nil
        print "Cannot generate schedule! No room matches closing room constraints!\n"
        exit
    end

    if timeScheduleForEvent.has_key?(:mealTimes) == true
        hackRoomsDetailArr = findHackRooms(buildings, computersNeeded, hackTimesArr, eventType[1], true)
        if hackRoomsDetailArr == nil
            print "Cannot generate schedule! No room matches hack room constraints!\n"
            exit
        end

        arrOfMealTimes = timeScheduleForEvent[:mealTimes]
        mealRoomsDetails = findMealRooms(buildings, mealAttendees, arrOfMealTimes, eventType[2])
        if mealRoomsDetails == nil
            print "Cannot generate schedule! No room matches meal room constraints!\n"
            exit
        end
        return {
            opening: openingRoomDetailArr,
            closing: closingRoomDetailArr,
            meals: mealRoomsDetails,
            hacks: hackRoomsDetailArr
        }
    end

    hackRoomsDetailArr = findHackRooms(buildings, computersNeeded, hackTimesArr, eventType[1], false)
        if hackRoomsDetailArr == nil
            print "Cannot generate schedule! No room matches hack room constraints!\n"
            exit
        end

    return {
        opening: openingRoomDetailArr,
        closing: closingRoomDetailArr,
        hacks: hackRoomsDetailArr
    }

end

# Time Complexity: O(n * m * l) where n is the number of seesion in which attendees are hacking, m is the number of rooms assigned to the hacking attendees, and l is the length of output CSV attributes.
# Space Complexity: O(?)
# Format the schedule hashMap a bit to properly write to the CSV.
def formatForOutputCSV(hashMap, attributes)
    opening = hashMap[:opening]
    closing = hashMap[:closing]
    openingRow = []
    closingRow = []
    hackingRows = []
    hacks = hashMap[:hacks]
    for attr in 0 .. attributes.length-1
        if attributes[attr] == "Date"
            openingRow.push(opening[3][0].year.to_s + "-" + opening[3][0].month.to_s + "-" + opening[3][0].day.to_s)
        elsif attributes[attr] == "Time"
            openingRow.push(opening[3][0])
        elsif attributes[attr] == "Building"
            openingRow.push(opening[0])
        elsif attributes[attr] == "Room"
            openingRow.push(opening[1])
        elsif attributes[attr] == "Purpose"
            openingRow.push(opening[4])
        else
            openingRow.push(opening[2][attributes[attr]])
        end
    end

    for attr in 0 .. attributes.length-1
        if attributes[attr] == "Date"
            closingRow.push(closing[3][0].year.to_s + "-" + closing[3][0].month.to_s + "-" + closing[3][0].day.to_s)
        elsif attributes[attr] == "Time"
            closingRow.push(closing[3][0])
        elsif attributes[attr] == "Building"
            closingRow.push(closing[0])
        elsif attributes[attr] == "Room"
            closingRow.push(closing[1])
        elsif attributes[attr] == "Purpose"
            closingRow.push(closing[4])
        else
            closingRow.push(closing[2][attributes[attr]])
        end
    end

    for hackSesh in 0 .. hacks.length-1
        theRoomsForThisSesh = []
        for roomsForHackSesh in  0 .. hacks[hackSesh].length - 1
            hackRow = []
            for attr in 0 .. attributes.length-1
                if attributes[attr] == "Date"
                    hackRow.push(hacks[hackSesh][roomsForHackSesh][3][0].year.to_s + "-" + hacks[hackSesh][roomsForHackSesh][3][0].month.to_s + "-" + hacks[hackSesh][roomsForHackSesh][3][0].day.to_s)
                elsif attributes[attr] == "Time"
                    hackRow.push(hacks[hackSesh][roomsForHackSesh][3][0])
                elsif attributes[attr] == "Building"
                    hackRow.push(hacks[hackSesh][roomsForHackSesh][0])
                elsif attributes[attr] == "Room"
                    hackRow.push(hacks[hackSesh][roomsForHackSesh][1])
                elsif attributes[attr] == "Purpose"
                    hackRow.push(hacks[hackSesh][roomsForHackSesh][4])
                else
                    hackRow.push(hacks[hackSesh][roomsForHackSesh][2][attributes[attr]])
                end
            end
            theRoomsForThisSesh.push(hackRow)
        end
        hackingRows.push(theRoomsForThisSesh)
    end

    if hashMap.has_key?(:meals) == true
        meals = hashMap[:meals]
        mealsArr=[]
        for mealsSesh in 0 .. meals.length-1
                mealRow = []
                for attr in 0 .. attributes.length-1
                    if attributes[attr] == "Date"
                        mealRow.push(meals[mealsSesh][3][0].year.to_s + "-" + meals[mealsSesh][3][0].month.to_s + "-" + meals[mealsSesh][3][0].day.to_s)
                    elsif attributes[attr] == "Time"
                        mealRow.push(meals[mealsSesh][3][0])
                    elsif attributes[attr] == "Building"
                        mealRow.push(meals[mealsSesh][0])
                    elsif attributes[attr] == "Room"
                        mealRow.push(meals[mealsSesh][1])
                    elsif attributes[attr] == "Purpose"
                        mealRow.push(meals[mealsSesh][4])
                    else
                        mealRow.push(meals[mealsSesh][2][attributes[attr]])
                    end
                end
            mealsArr.push(mealRow)
        end
        return [openingRow, closingRow, hackingRows, mealsArr]
    end
    return [openingRow, closingRow, hackingRows]
end

# Time Complexity: O(n * m)
# Space Complexity: O(?)
# Sort the schedule sections by time from earliest to latest.
def sortTimes(arr)
    loop do
        for el in 0 .. arr.length - 2
            if arr[el][1] > arr[el+1][1]
                arr[el], arr[el+1] = arr[el+1], arr[el]
                swapped = true
            end
        end
        break if not swapped
    end
    return arr
end
