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

# Time Complexity: O(1)
# Time Complexity: O(1)
# Checks to see if capacity value in given CSV is valid.
def validCapacityValue(val)
    return (val.to_i > 0)
end

# Time Complexity: O(1)
# Time Complexity: O(1)
# Checks to see if food allowed value in given CSV is valid.
def validFoodAllowedValue(val)
    arr = ["yes", "no"]
    return arr.include?(val.downcase)
end

# Time Complexity: O(1)
# Time Complexity: O(1)
# Checks to see if computers available value in given CSV is valid.
def validComputersAvailableValue(val)
    arr = ["yes", "no"]
    return arr.include?(val.downcase)
end

# Time Complexity: O(1)
# Time Complexity: O(1)
# Checks to see if seating type value in given CSV is valid.
def validSeatingTypeValue(val)
    arr = ["tiered", "level"]
    return arr.include?(val.downcase)
end

# Time Complexity: O(1)
# Time Complexity: O(1)
# Checks to see if Room value in given CSV is valid.
def validRoomValue(val)
    return val.to_i > 0
end

# Time Complexity: O(n)
# Time Complexity: O(1)
# Checks to see if string given contains any unacceptable characters.
def areAcceptableChars1(s)
    unacceptableChars = []
    for ascii in 0 .. 128
        if !(ascii >= 48 and ascii <= 57) and (ascii != 45)
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
# Time Complexity: O(1)
# 
def areAcceptableChars2(s)
    unacceptableChars = []
    for ascii in 0 .. 128
        if !(ascii >= 48 and ascii <= 58) and (ascii != "m".ord and ascii != "M".ord) and ( ascii != "a".ord and ascii != "A".ord) and (ascii != "p".ord and ascii != "P".ord) and (ascii != 32)
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
# Time Complexity: O(1)
# 
def areAcceptableChars3(s)
    unacceptableChars = []
    for ascii in 0 .. 128
        if !(ascii >= 48 and ascii <= 58)
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
# Time Complexity: O(1)
# 
def areAcceptableChars4(s)
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
# Space Complexity: O(1)
# Checks to see if date input by user is valid.
def dateGivenIsValid(dateInput)
    if areAcceptableChars1(dateInput) == false
        return -1
    end
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
    if areAcceptableChars2(timeInput) == false
        return -1
    end
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

    if !(hours.to_i > 0 and hours.to_i <= 12)
        return -1
    end

    if !(minutes.to_i >= 0 and minutes.to_i < 60)
        return -1
    end
    begin
        # time = Time.new(date.year, date.mon, date.mday, hours, minutes, 0)
        time = convertStringArrToTime(date.year, date.mon, date.mday,  givenTime)
    rescue
        return -1
    end
    return time
end

# Time Complexity: O(n)
# Time Complexity: O(1)
# Checks to see if duration input by user is valid.
def durationTimeGivenIsValid(startTime, durationInput)
    if areAcceptableChars3(durationInput) == false
        return -1
    end
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

# Time Complexity: O(n)
# # Space Complexity: O(1)
# Checks to see if attendees input by user is valid.
def valueGivenIsValidNumeric(input)
    result = areAcceptableChars4(input)
    if result == false
        return -1
    end

    if input.to_i < 1
        return -1
    end
    return input.to_i
end

# Time Complexity: O(n)
# Time Complexity: O(1)
# Checks to see if potential time given for event can be scheduled in room.
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

# Time Complexity: O(1)
# Time Complexity: O(1)
# If invalid data is found in sample CSV, function allows the user to decide how to handle the conflict.
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
                print "\nInvalid response. Please enter something valid."
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
                print "\nInvalid response. Please enter something valid."
                print "If correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
            else
                print "Conflict resolved! Value for \"Computers Available\" has been updated! CSV processing shall continue.\n\n"
                break
            end
        elsif attributeWhereConflictFound.downcase == "food allowed"
            response = gets.chomp()
            if response.downcase == "x"
                print "Conflict resolved! Row has been dropped. CSV processing shall continue.\n\n"
                return 0
            elsif validFoodAllowedValue(response) == false
                print "\nInvalid response. Please enter something valid."
                print "If correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
            else
                print "Conflict resolved! Value for \"Food Allowed\" has been updated! CSV processing shall continue.\n\n"
                break
            end
        elsif attributeWhereConflictFound.downcase == "seating type"
            response = gets.chomp()
            if response.downcase == "x"
                print "Conflict resolved! Row has been dropped. CSV processing shall continue.\n\n"
                return 0
            elsif validSeatingTypeValue(response) == false
                print "\nInvalid response. Please enter something valid."
                print "If correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
            else
                print "Conflict resolved! Value for \"Seating Type\" has been updated! CSV processing shall continue.\n\n"
                break
            end
        else
            response = gets.chomp()
            if response.downcase == "x"
                print "Conflict resolved! Row has been dropped. CSV processing shall continue.\n\n"
                return 0
            elsif validRoomValue(response) == false
                print "\nInvalid response. Please enter something valid."
                print "If correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
            else
                print "Conflict resolved! Value for \"Room\" has been updated! CSV processing shall continue.\n\n"
                break
            end
        end
    end
    rowWhereConflictFound[index] = response
    return rowWhereConflictFound
end
