require 'csv'
require 'date'
require 'time'
require './UserPreferences.rb'


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

def inPM(s)
    if s.downcase == "pm"
        return true
    end
    return false
end

def convertStringArrToDate(arr)
    year = arr[0].to_i
    month = arr[1].to_i
    day = arr[2].to_i
    return Date.new(year, month, day)
end

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

def attendeesGivenIsValid(attendessInput)
    unacceptableChars = []
    for ascii in 0 .. 128
        if !(ascii >= 48 and ascii <= 57)
            unacceptableChars.push(ascii.chr)
        end
    end
    attendessInput.each_char{|c|
        if unacceptableChars.include?(c)
            return -1
        end
    }

    if attendessInput.to_i < 1
        return -1
    end
    return attendessInput.to_i
end

# Read Columns of CSV
def readAttributes(fileName)
    file = CSV.read(Dir.getwd + "/" + fileName)
    attributes = file[0]
    return attributes
end

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

# Input prompt function to read the second CSV given.
def getRoomsReservationCSV()
    print "Enter the filename of the Reserved Rooms CSV (Enter EXIT to quit): "
    while true
        theFileNameReservation = gets.chomp()
        isValid = fileNameGivenIsValid(theFileNameRoomReservation)
        if isValid == -1
            print "File \"" + theFileNameRoomReservation + "\" found. Please make sure the file your entering is located within the same directory.\n\n"
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
                value = value.to_i
            end
            roomDetails[attributes[attr]] = value
        end
        buildingsHash[building][room] = roomDetails
    end
    return buildingsHash
end

# To be implemented.
def saveRoomBooking(fileName, buildingsHash, attributes)
    file = CSV.read(Dir.getwd + "/" + fileName)
    for row in 1 .. file.length-1
        building = file[row][0]
        room = file[row][1]
        roomDetails = buildingsHash[building][room]
        year = ""
        month = ""
        day = ""
        for attr in 2 .. file[row].length-1
            value = file[row][attr]
            if attributes[attr] == "Date"
                dateArray = value.split("-")
                year = dateArray[0]
                month = dateArray[1]
                day = dateArray[2]
                roomDetails[attributes[attr]] = convertStringArrToDate(dateArray)
            elsif attributes[attr] == "Time" or attributes[attr] == "During"
                timeArray = value.split(" ")
                roomDetails[attributes[attr]] = convertStringArrToTime(year, month, day, timeArray)
            else
                roomDetails[attributes[attr]] = value
            end
        end
        buildingsHash[building][room] = roomDetails
    end
    return buildingsHash
end

def getUserPrefences()
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
        isValid = attendeesGivenIsValid(attendees)
        if isValid == -1
            print "Attendess number, " + attendees + "\", not valid.\n\n"
            print "Enter the expected number of attendees (e.g., 25): "
        else
            attendees = isValid
            break
        end
    end
    prefences = UserPrefences.new(date, startTime, durationTime, attendees)
    return prefences
end

def schedule(theBuildings, theUserPreferences)
    amountEating = theUserPreferences.getAttendees * 0.6
    amountWhoNeedsComputers = theUserPreferences.getAttendees * 0.1
    additionalHoursNeededForMeal = theUserPreferences.getDuration/6
    durationExtender = 4 + additionalHoursNeededForMeal;
    theUserPreferences.addToDuration(durationExtender)

    eventType = [
        "Opening Session",
        "Group Work",
        "Meal",
        "Closing Session"
    ]
end

# Main Function.
