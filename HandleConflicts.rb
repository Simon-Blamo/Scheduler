require 'csv'
require 'date'
require 'time'

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
    givenTime = timeInput.split(" ")
    if givenTime.length != 2
        return -1
    end

    if validHourPeriods.include?(givenTime[1].downcase) == false
        return -1
    end

    if givenTime[0].split(":").length != 2
        return -1
    end
    hours = givenTime[0].split(":")[0]
    minutes = givenTime[0].split(":")[1]

    if !(hours.to_i > 0 and hours.to_i < 12)
        return -1
    end

    if !(minutes.to_i >= 0 and minutes.to_i < 60)
        return -1
    end
    begin
        time = Time.new(date.year, date.mon, date.mday, hours, minutes, 0)
    rescue
        return -1
    end
    return time
end

# Time Complexity: O(n)
# Time Complexity: O(1)
# Checks to see if duration input by user is valid.
def durationTimeGivenIsValid(startTime, durationInput)
    givenTime = durationInput.split(":")
    if givenTime.length != 2
        return -1
    end
    hours = givenTime[0]
    minutes = givenTime[1]

    if !(hours.to_i > 0 and hours.to_i <= 27)
        return -1
    end

    if !(minutes.to_i >= 0 and minutes.to_i < 60)
        return -1
    end

    duration = convertStringArrToTimeDuration(startTime, [hours, minutes])
    return [duration, [hours, minutes]]
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

def validSeatingTypeValue(val)
    arr = ["tiered", "level"]
    return arr.include?(val.downcase)
end

def validRoomValue(val)
    return val.to_i > 0
end

def areAcceptableChars(s)
    unacceptableChars = []
    for ascii in 0 .. 128
        if !(ascii >= 48 and ascii <= 57)
            unacceptableChars.push(ascii.chr)
        end
    end
    s.each_char{|c|
        if unacceptableChars.include?(c)
            return false
        end
    }
    return true
end

# Time Complexity: O(n)
# # Space Complexity: O(1)
# Checks to see if attendees input by user is valid.
def valueGivenIsValidNumeric(input)
    result = areAcceptableChars(input)
    if result == false
        return -1
    end

    if input.to_i < 1
        return -1
    end
    return input.to_i
end

# need to explain and refine
def timeSlotIsValid(timeSlotArray, potentialTime)
    if timeSlotArray.length > 0
        for el in 0 .. timeSlotArray.length - 1
            if potentialTime.between?(timeSlotArray[el][0], timeSlotArray[el][1]) == true
                return false
            end
        end
    end
    return true
end

# need to explain and refine
def handleConflict1(conflictVal, attributeWhereConflictFound, rowWhereConflictFound, index)
    print "\nERROR\n"
    print "\nConflict found in row:\n\n"
    print rowWhereConflictFound
    print "\n\n Value, \"" + conflictVal + "\", is not valid for attribute \"" + attributeWhereConflictFound +".\"\n\n"
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
