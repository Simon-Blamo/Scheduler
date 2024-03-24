require './Utils.rb'

# Time Complexity: O(n)
# Error checking function. Checks if filename given is valid.
def file_name_given_is_valid(file_name)
    if file_name.downcase == "exit"
        exit
    end
    begin
        CSV.read(Dir.getwd + "/" + file_name)
    rescue
        return false
    end
    return true
end

# Time Complexity: O(1)
# Checks to see if capacity value in given CSV is valid.
def valid_capacity_value(value)
    result = (value.to_i > 0)
    return result
end

# Time Complexity: O(1)
# Checks to see if food allowed value in given CSV is valid.
def valid_food_allowed_value(value)
    valid_food_array = ["yes", "no"]
    result = valid_food_array.include?(value.downcase)
    return result
end

# Time Complexity: O(1)
# Checks to see if computers available value in given CSV is valid.
def valid_computers_available_value(value)
    valid_computers_array = ["yes", "no"]
    result = valid_computers_array.include?(value.downcase)
    return result
end

# Time Complexity: O(1)
# Checks to see if seating type value in given CSV is valid.
def valid_seating_type_value(value)
    valid_seats_array = ["tiered", "level"]
    result = valid_seats_array.include?(value.downcase)
    return result
end

# Time Complexity: O(1)
# Checks to see if Room value in given CSV is valid.
def valid_room_value(value)
    result = value.to_i > 0
    return result
end

# Time Complexity: O(n)
# Checks to see if date input by user is valid.
def date_given_is_valid(date_input)
    if user_value_contains_only_acceptable_chars(true, false, false, false, date_input) == false
        return false
    end


    given_date = date_input.split("-")
    if given_date.length != 3
        return false
    end


    day = convert_string_array_to_date(given_date)


    if day == false
        return false
    end
    current_day = DateTime.now
    if (current_day > day)
        return false
    end
    return day
end

# Time Complexity: O(n)
# Checks to see if start time input by user is valid.
def start_time_given_is_valid(date, time_input)
    if user_value_contains_only_acceptable_chars(false, true, false, false, time_input) == false
        return false
    end
    valid_hour_periods = ["am", "pm"]
    given_time = time_input.split(" ")
    if given_time.length != 2
        return false
    end

    if valid_hour_periods.include?(given_time[1].downcase) == false
        return false
    end

    if given_time[0].split(":").length != 2
        return false
    end
    hours = given_time[0].split(":")[0]
    minutes = given_time[0].split(":")[1]

    if !(hours.to_i > 0 and hours.to_i <= 12)
        return false
    end

    if !(minutes.to_i >= 0 and minutes.to_i < 60)
        return false
    end

    time = convert_string_array_to_time(date.year, date.mon, date.mday, given_time)

    return time
end

# Time Complexity: O(n)
# Checks to see if duration input by user is valid.
def duration_time_given_is_valid(start_time, duration_input)
    if user_value_contains_only_acceptable_chars(false, false, true, false, duration_input) == false
        return false
    end
    given_time = duration_input.split(":")
    if given_time.length != 2
        return false
    end
    hours = given_time[0]
    minutes = given_time[1]

    duration_hour_range_start = 0
    duration_hour_range_end = 48

    if !(hours.to_i >= duration_hour_range_start and hours.to_i <= duration_hour_range_end)
        return false
    end

    minutes_range_start = 0
    minutes_range_end = 59
    if !(minutes.to_i >= minutes_range_start and minutes.to_i <= minutes_range_end)

        return false
    end

    duration = convert_string_array_to_time_duration(start_time, [hours, minutes])
    return [duration, [hours, minutes]]
end

# Time Complexity: O(n)
# Checks to see if attendees input by user is valid.
def value_given_is_valid_numeric(input, for_capacity)
    if for_capacity == true
        if user_value_contains_only_acceptable_chars(false, false, false, true, input) == false
            return false
        end
    end
    if input.to_i < 1
        return false
    end
    return input.to_i
end

# Time Complexity: O(n)
# Checks to see if potential time given for event can be scheduled in room.
def time_slot_is_valid(time_slot_array, potential_time)
    if time_slot_array.length > 0
        for element in 0 .. time_slot_array.length - 1
            time_slot_start = time_slot_array[element][0]
            time_slot_end = time_slot_array[element][1]
            if potential_time.between?(time_slot_start, time_slot_end) == true
                return false
            end
        end
    end
    return true
end

# Time Complexity O(n)
# Method to check whether or not if the input given is valid.
def user_value_contains_only_acceptable_chars(testing_event_date, testing_start_time, testing_duration_time, testing_capacity, user_input)
    array_of_unacceptable_chars = []

    ascii_start = 0
    ascii_end = 127
    ascii_space = 32
    ascii_hyphen = 45
    ascii_zero = 48
    ascii_nine = 57
    ascii_colon = 58
    ascii_m = "m".ord
    ascii_M = "M".ord
    ascii_a = "a".ord
    ascii_A = "A".ord
    ascii_p = "p".ord
    ascii_P = "P".ord

    for ascii_value in ascii_start .. ascii_end
        if testing_event_date == true
            if !(ascii_value >= ascii_zero and ascii_value <= ascii_nine) and !(ascii_value == ascii_hyphen)
                array_of_unacceptable_chars.push(ascii_value.chr)
            end
        elsif testing_start_time == true
            if !(ascii_value >= ascii_zero and ascii_value <= ascii_colon) and (ascii_value != ascii_m and ascii_value != ascii_M) and ( ascii_value != ascii_a and ascii_value != ascii_A) and (ascii_value != ascii_p and ascii_value != ascii_P) and (ascii_value != ascii_space)
                array_of_unacceptable_chars.push(ascii_value.chr)
            end
        elsif testing_duration_time == true
            if !(ascii_value >= ascii_zero and ascii_value <= ascii_colon)
                array_of_unacceptable_chars.push(ascii_value.chr)
            end
        elsif testing_capacity == true
            if !(ascii_value >= ascii_zero and ascii_value <= ascii_nine)
                array_of_unacceptable_chars.push(ascii_value.chr)
            end
        end
    end


    user_input.each_char{|c|
        if array_of_unacceptable_chars.include?(c)
            return false
        end
    }
    return true
end

# Time Complexity O(1)
# Method to notify user of status of conflict handling.
def print_conflict_not_resolved_message_1()
    print "\nInvalid response. Please enter something valid."
    print "\n\nIf correct value known, enter below. \nIf the correct value is not known, enter \"X\". The row will be dropped. \nEnter value: "
end

# Time Complexity O(1)
# Method to notify user of status of conflict handling.
def print_conflict_resolved_message_1()
    print "Conflict resolved! Row has been dropped. CSV processing shall continue.\n\n"
end

# Time Complexity O(1)
# Method to notify user of status of conflict handling.
def print_conflict_resolved_message_2(attribute)
    print "Conflict resolved! Value for \" " + attribute + "\" has been updated! CSV processing shall continue.\n\n"
end


# Time Complexity: O(1)
# If invalid data is found in sample CSV, function allows the user to decide how to handle the conflict.
def handle_conflict_in_csv(conflict_value, attribute_where_conflict_found, row_where_conflict_found, index)
    loop_status = true
    print "\nERROR\n"
    print "\nConflict found in row:\n\n"
    print row_where_conflict_found
    print "\n\n Value, \"" + conflict_value + "\", is not valid for attribute \"" + attribute_where_conflict_found +"\".\n\n"
    print "If correct value known, enter below. \nIf the correct value is not known, enter \"x\". The row will be dropped. \n\nIf you wish skip and drop the any remaining conflicts that may appear, enter \"X\". \n\nEnter value: "
    while loop_status
        response = gets.chomp()
        if response.downcase == "x"
            print_conflict_resolved_message_1()

            if response == "X"
                return [nil, true]
            end
            loop_status = false
            return [nil, false]
        else
            if attribute_where_conflict_found == "capacity"
                if value_given_is_valid_numeric(response, true) == false
                    print_conflict_not_resolved_message_1()
                else
                    loop_status = false
                    print_conflict_resolved_message_2(attribute_where_conflict_found)
                end
            elsif attribute_where_conflict_found.downcase == "computers available"
                if valid_computers_available_value(response) == false
                    print_conflict_not_resolved_message_1()
                else
                    loop_status = false
                    print_conflict_resolved_message_2(attribute_where_conflict_found)
                end
            elsif attribute_where_conflict_found.downcase == "seating type"
                if valid_seating_type_value(response) == false
                    print_conflict_not_resolved_message_1()
                else
                    loop_status = false
                    print_conflict_resolved_message_2(attribute_where_conflict_found)
                end
            elsif attribute_where_conflict_found.downcase == "food allowed"
                if valid_food_allowed_value(response) == false
                    print_conflict_not_resolved_message_1()
                else
                    loop_status = false
                    print_conflict_resolved_message_2(attribute_where_conflict_found)
                end
            else
                if valid_room_value(response) == false
                    print_conflict_not_resolved_message_1()
                else
                    loop_status = false
                    print_conflict_resolved_message_2(attribute_where_conflict_found)
                end
            end
        end
    end
    row_where_conflict_found[index] = response
    return row_where_conflict_found
end
