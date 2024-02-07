require 'csv'
require 'date'
require 'time'
require './UserPreferences.rb'


# Time Complexity: O(n)
# Space Complexity: O(1)
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
    return 1
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Checks if timeInput given by user is in the PM or not.
def inPM(s)
    if s.downcase == "pm"
        return true
    end
    return false
end

# Time Complexity: O(1)
# Space Complexity: O(1)
# Convert a String Array to a Date object.
def convertStringArrToDate(arr)
    year = arr[0].to_i
    month = arr[1].to_i
    day = arr[2].to_i
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
        time = Time.new(year.to_i, month.to_i, day.to_i, hours, minutes, 0, "-5:00")
    else
        hours = (arr[0].split(":")[0].to_i)
        hours = hours == 12 ? 0 : hours
        minutes = arr[0].split(":")[1].to_i
        time = Time.new(year.to_i, month.to_i, day.to_i, hours, minutes, 0, "-5:00")
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
# Checks to see if date input by user is valid.
def dateGivenIsValid(dateInput)
    givenDate = dateInput.split("-")
    if givenDate.length != 3
        return -1
    end

    begin
        day = convertStringArrToDate(givenDate)
    rescue
        return -1
    end
    currentDay = DateTime.now
    if (currentDay > day)
        return -1
    end
    return day
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Checks to see if start time input by user is valid.
def startTimeGivenIsValid(date, timeInput)
    validHourPeriods = ["am", "pm"]
    givenTime = timeInput.split
    if givenTime.length != 2
        return -1
    end

    if validHourPeriods.include?(givenTime[1].downcase) == false
        return -1
    end

    if givenTime[0].split(":") != 2
        return -1
    end
    hours = givenTime[0].split(":")[0]
    minutes = givenTime[0].split(":")[1]

    if !(hours.to_i > 0 and hours.to_i < 12) or !(minutes.to_i >= 0 and minutes.to_i < 60)
        return -1
    end
    begin
        time = Time.new(date.year, date.mon, date.mday, hoursAndMins[0], hoursAndMins[1], 0, "-5:00")
    rescue
        return -1
    end
    return time
end

# Time Complexity: O(n)
# Time Complexity: O(1)
# Checks to see if duration input by user is valid.
def durationTimeGivenIsValid(durationInput)
    givenTime = durationInput.split(":")
    if givenTime.length != 2
        return -1
    end
    hours = givenTime[0]
    minutes = givenTime[1]
    duration = [hours, minutes]
    return duration
end

def validCapacityValue(val)
    return (val.to_i > 0)
end

def validFoodAllowedValue(val)
    arr = ["yes", "no"]
    return arr.include?(val.downcase)
end

def validComputersAvailableValue(val)
    arr = ["yes", "no"]
    return arr.include?(val.downcase)
end

# Time Complexity: O(n)
# # Space Complexity: O(1)
# Checks to see if attendees input by user is valid.
def valueGivenIsValidNumeric(input)
    unacceptableChars = []
    for ascii in 0 .. 128
        if !(ascii >= 48 and ascii <= 57)
            unacceptableChars.push(ascii.chr)
        end
    end
    input.each_char{|c|
        if unacceptableChars.include?(c)
            return -1
        end
    }

    if input.to_i < 1
        return -1
    end
    return input.to_i
end

# need to explain and refine
def timeSlotIsValid(timeSlotArray, potentialTime)
    for el in 0 .. timeSlotArray.length - 1
        if potentialTime.between?(el[0], el[1]) == true
            return false
        end
    end
    return true
end

# need to explain and refine
def handleConflict1(conflictVal, attributeWhereConflictFound, rowWhereConflictFound, index)
    print "ERROR\n"
    print "\nConflict found in row:\n\n"
    print rowWhereConflictFound
    print "\n\n Value,\"" + conflictVal + "\", is not valid for attribute \"" + attributeWhereConflictFound +"\"\n\n"
    print "If correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
    while true
        if attributeWhereConflictFound.downcase == "capacity"
            response = gets.chomp()
            if response.downcase == "x"
                print "Conflict resolved! Row has been dropped. CSV processing shall continue.\n\n"
                return 0
            elsif valueGivenIsValidNumeric(response) == -1
                print "Invalid response. Please enter something valid."
                print "If correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
            else
                print "Conflict resolved! Value for \"Capacity\" has been updated! CSV processing shall continue.\n\n"
                break
            end
        elsif attributeWhereConflictFound.downcase == "computers available"
            response = gets.chomp()
            if response.downcase == "x"
                print "Conflict resolved! Row has been dropped. CSV processing shall continue.\n\n"
                return 0
            elsif validComputersAvailableValue(response) == false
                print "Invalid response. Please enter something valid."
                print "If correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
            else
                print "Conflict resolved! Value for \"Computers Available\" has been updated! CSV processing shall continue.\n\n"
                break
            end
        else
            response = gets.chomp()
            if response.downcase == "x"
                print "Conflict resolved! Row has been dropped. CSV processing shall continue.\n\n"
                return 0
            elsif validFoodAllowedValue(response) == false
                print "Invalid response. Please enter something valid."
                print "If correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
            else
                print "Conflict resolved! Value for \"Food Allowed\" has been updated! CSV processing shall continue.\n\n"
                break
            end
        end
    end
    rowWhereConflictFound[index] = response
    return rowWhereConflictFound

end

# need to implement
def handleConflict2

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
        for attr in 2 .. file[row].length-1
            value = file[row][attr]
            if attributes[attr] == "Capacity"
                if validCapacityValue(value) == false
                    results = handleConflict1(value, attributes[attr], file[row], attr)
                    if results == 0
                        next
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
                        next
                    else
                        file[row] = results
                        value = file[row][attr]
                    end
                end
            elsif attributes[attr] == "Computers Available"
                if validComputersAvailableValue(value) == false
                    results = handleConflict1(value, attributes[attr], file[row], attr)
                    if results == 0
                        next
                    else
                        file[row] = results
                        value = file[row][attr]
                    end
                end
            end
            roomDetails[attributes[attr]] = value
        end
        if buildingsHash.has_key?(building) == false
            buildingsHash[:building] = {room: roomDetails}
        else
            buildingsHash[building][room] = roomDetails
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
        roomDetails = buildingsHash[building][room]
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
                roomDetails[attributes[attr]] = convertStringArrToDate(dateArray)
            elsif attributes[attr] == "Time" or attributes[attr] == "During"
                if attributes[attr] == "Time"
                    if roomDetails.has_key?("timeSlotArray") == false
                        roomDetails["timeSlotArray"] = []
                    end
                    timeArray = value.split(" ")
                    #roomDetails[attributes[attr]] = convertStringArrToTime(year, month, day, timeArray)
                    pendingTimeAddition.push(convertStringArrToTime(year, month, day, timeArray))
                    if timeSlotIsValid(roomDetails["timeSlotArray"], pendingTimeAddition[0]) == false
                        roomDetails = -1
                        break
                    end
                else
                    eventEnd = convertStringArrToTimeDuration(pendingTimeAddition[0], value.split(":"))
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
        end
    end
    return buildingsHash
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Function to get user's desired preferences for their upcoming event.
def getUserPrefernces()
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
        isValid = startTimeGivenIsValid(startTime)
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
        isValid = durationTimeGivenIsValid(durationTime)
        if isValid == -1
            print "Duration time, \"" + durationTime + "\", not valid.\n\n"
            print "Enter the duration of your event (e.g., 2:20): "
        else
            durationTime = isValid
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
    preferences = UserPreferences.new(date, startTime, durationTime, attendees)
    return preferences
end

# need to finish
def findOpeningRoom(building, userP)

end

# need to finish
def canHaveMeals(building, amountEating)

end

# need to finish
def canHack(building, amountWhoNeedsComputer)

end

# need to finish
def computeAmountOfComputersInBuilding(building)

end

# Time Complexity: Probably bad.
# Space Complexity: Probably bad.
# TBD
def schedule(theBuildings, theUserPreferences)
    amountEating = theUserPreferences.getAttendees * 0.6
    amountWhoNeedsComputers = theUserPreferences.getAttendees * 0.1
    timeNeededForOpeningandClosingSession = 4
    theUserPreferences.addToDuration(timeNeededForOpeningandClosingSession)
    additionalHoursNeededForMeal = theUserPreferences.getDuration/6
    theUserPreferences.addToDuration(additionalHoursNeededForMeal)

    eventType = [
        "Opening Session",
        "Group Work",
        "Meal",
        "Closing Session"
    ]

    theBuildings.each do |key, value|

    end
end
