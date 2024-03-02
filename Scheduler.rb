require './Handle_Conflicts.rb'
require './Campus.rb'
require './UserPreferences.rb'

# Time Complexity: O(n)
# Space Complexity: O(1)
# Input prompt function to Read the first CSV given.
def get_rooms_csv()
    loop_status = true
   print "Enter the filename of the Rooms CSV (Enter EXIT to quit): "
    while loop_status
        the_file_name_room = gets.chomp()
        is_valid = file_name_given_is_valid(the_file_name_room)
        if is_valid == false
            print "File \"" + the_file_name_room + "\" not found. Please make sure the file you're entering is located within the same directory.\n\n"
            print "Enter the filename of the Rooms CSV (Enter EXIT to quit): "
        else
            loop_status = false
        end
    end
    room_attributes = read_attributes(the_file_name_room)
    return [the_file_name_room, room_attributes]
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Input prompt function to read the second CSV given.
def get_rooms_reservation_csv()
    loop_status = true
    print "Enter the filename of the Reserved Rooms CSV (Enter EXIT to quit): "
    while loop_status
        the_file_name_reservation = gets.chomp()
        is_valid = file_name_given_is_valid(the_file_name_reservation)
        if is_valid == false
            print "File \"" + the_file_name_reservation  + "\" not found. Please make sure the file you're entering is located within the same directory.\n\n"
            print "Enter the filename of the Reserved Rooms CSV (Enter EXIT to quit): "
        else
            loop_status = false
        end
    end
    reservation_attributes = read_attributes(the_file_name_reservation)
    return [the_file_name_reservation, reservation_attributes]
end

# Time Complexity: ??? where n is the number of rows in the files, and m is the number of attributes.
# Space Complexity: O(n * m)
# Reads the Room details, returns a hashmap with the key-value pair with the keys being the building name,
# and the value being ANOTHER hashmap with the key-value pair with its keys being the room number, and the
# values of that being yet ANOTHER hashmap with the key-value pair with its keys being the attribute(column), and the
# values being the value for that respective attribute for that row.
def save_room_details(file_name, attributes)
    return_campus = Campus.new();
    return_campus.populate_building_hash_key(file_name)
    file = CSV.read(Dir.getwd + "/" + file_name)
    start_of_values = 1
    end_of_values = file.length-1
    skip_conflicts = false

    for row in start_of_values .. end_of_values
        row_discared = false
        building_found_in_row = file[row][0]
        building = return_campus.get_building(building_found_in_row)

        if building == nil
            new_building_object = Building.new()
            return_campus.update_building(building_found_in_row, new_building_object)
            building = return_campus.get_building(building_found_in_row)
        end

        room_found_in_row = file[row][1]
        if valid_room_value(room_found_in_row) == false
            if skip_conflicts == false
                result_of_conflict_handling = handle_conflict_in_csv(room_found_in_row, "Room", file[row], 1)
                if result_of_conflict_handling[0] == nil
                    skip_conflicts = result_of_conflict_handling[1]
                    next
                end
            else
                next
            end

        end

        room_initialized_in_building = building.has_room?(room_found_in_row)
        if room_initialized_in_building == false
            new_room_object = Room.new(room_found_in_row)
            room = new_room_object
        else
            room = building.get_room(room_found_in_row)
        end


        capacity_attribute = "Capacity"
        computers_attribute = "Computers Available"
        seating_type_attribute = "Seating Type"
        food_attribute = "Food Allowed"

        array_of_possible_conflict_values = [
            capacity_attribute,
            computers_attribute,
            seating_type_attribute,
            food_attribute
        ]

        capacity_attribute_numeric = 2
        room_type_attribute_numeric = file[row].length-1
        for attribute in capacity_attribute_numeric .. room_type_attribute_numeric
            value = file[row][attribute]
            is_valid_value = true
            if attributes[attribute] in array_of_possible_conflict_values
                if attributes[attribute] == capacity_attribute
                    is_valid_value = valid_capacity_value(value)
                elsif attributes[attribute] == computers_attribute
                    is_valid_value = valid_computers_available_value(value)
                elsif attributes[attribute] == seating_type_attribute
                    is_valid_value = valid_seating_type_value(value)
                elsif attributes[attribute] == food_attribute
                    is_valid_value = valid_food_allowed_value(value)
                end

                if is_valid_value == false
                    if skip_conflicts == false
                        result_of_conflict_handling = handle_conflict_in_csv(value, attributes[attribute], file[row], attribute)
                        if result_of_conflict_handling[0] == nil
                            row_discared = true
                            skip_conflicts = result_of_conflict_handling[1]
                        else
                            file[row] = result_of_conflict_handling
                            value = file[row][attribute]
                        end
                    else
                        row_discared = true
                    end
                end
            end

            room.set_room_attribute(attributes[attribute], value)

        end
        if row_discared == true
            next
        end
        building.set_room(room)
    end
    return return_campus
end

# Time Complexity: O(n * m) where n is the number of rows in the files, and m is the number of attributes.
# Space Complexity: O(n * m)
# Reads the reservation details, and updates the building hashmap.
def save_room_reservation_details(file_name, attributes, campus_object)
    file = CSV.read(Dir.getwd + "/" + file_name)
    start_of_values = 1
    end_of_values = file.length-1

    for row in start_of_values .. end_of_values
        building_found_in_row = file[row][0]
        building = campus_object.get_building(building_found_in_row)

        if building == nil
            next
        end

        room_found_in_row = file[row][1]
        if building.has_room?(room_found_in_row) == false
            next
        end

        room = building.get_room(room_found_in_row)

        year = ""
        month = ""
        day = ""

        pending_time_addition = []

        date_attribute = 2
        booking_type_attribute = file[row].length-1

        for attribute in date_attribute .. booking_type_attribute
            value = file[row][attribute]
            if attributes[attribute] == "Date"
                date_array = value.split("-")
                year = date_array[0]
                month = date_array[1]
                day = date_array[2]
                date = convert_string_array_to_date(date_array)

                if date == false
                    room = nil
                    break
                end

                value = date
            elsif attributes[attribute] == "Time" or attributes[attribute] == "Duration"
                if attributes[attribute] == "Time"
                    if room.room_has_key?("Reservation Time Slots") == false
                        room.set_room_attribute("Reservation Time Slots", [])
                    end

                    time_array = value.split(" ")
                    start_time_of_reservation = convert_string_array_to_time(year, month, day, time_array)

                    # room.set_room_attribute(attributes[attribute], start_time_of_reservation)
                    pending_time_addition.push(start_time_of_reservation)

                    reservation_times = room.get_room_attribute("Reservation Time Slots")
                    if time_slot_is_valid(reservation_times, start_time_of_reservation) == false
                        room = nil
                        break
                    end
                    value = start_time_of_reservation
                else
                    start_time_of_reservation = pending_time_addition[0]
                    duration_array = value.split(":")
                    end_time_of_reservation = convert_string_array_to_time_duration(start_time_of_reservation, duration_array)

                    reservation_times = room.get_room_attribute("Reservation Time Slots")
                    if time_slot_is_valid(reservation_times, end_time_of_reservation) == false
                        room = nil
                        break
                    end
                    pending_time_addition.push(end_time_of_reservation)
                    value = end_time_of_reservation
                end
            end
            room.set_room_attribute(attributes[attribute], value)
        end

        if room != nil
            reservation_times = room.get_room_attribute("Reservation Time Slots")
            reservation_times.push(pending_time_addition)
            room.set_room_attribute("Reservation Time Slots", reservation_times)

            building.set_room(room)
        else
            building.delete_room(room_found_in_row)
        end
        campus_object.update_building(building_found_in_row, building)
    end
    return campus_object
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Function to get user's desired preferences for their upcoming event.
def get_user_preferences()
    loop_status = true
    print "Enter the desired date of your event (yyyy-mm-dd Format): "
    while loop_status
        date = gets.chomp()
        result = date_given_is_valid(date)
        if result == false
            print "Date, \"" + date + "\", not valid.\n\n"
            print "Enter the desired date of your event (yyyy-mm-dd Format): "
        else
            date = result
            loop_status = false
        end
    end

    loop_status = true
    print "\n\n"
    print "Enter the desired start time of your event (e.g., 1:00 PM): "
    while loop_status
        start_time = gets.chomp()
        result = start_time_given_is_valid(date, start_time)
        if result == false
            print "Start time, \"" + start_time + "\", not valid.\n\n"
            print "Enter the desired start time of your event (e.g., 1:00 PM): "
        else
            start_time = result
            loop_status = false
        end
    end

    loop_status = true
    print "\n\n"
    print "Enter the duration of your event (e.g., 2:20): "
    while loop_status
        duration_time = gets.chomp()
        result = duration_time_given_is_valid(start_time, duration_time)
        if result == false
            print "Duration time, \"" + duration_time + "\", not valid.\n\n"
            print "Enter the duration of your event (e.g., 2:20): "
        else
            duration_time = result[0]
            duartion_hours_minutes_array = result[1]
            loop_status = false
        end
    end

    loop_status = true
    print "\n\n"
    print "Enter the expected number of attendees (e.g., 25): "
    while loop_status
        attendees = gets.chomp()
        result = value_given_is_valid_numeric(attendees, false)
        if result == false
            print "Attendess number, " + attendees + "\", not valid.\n\n"
            print "Enter the expected number of attendees (e.g., 25): "
        else
            attendees = result
            loop_status = false
        end
    end

    preferences = UserPreferences.new(date, start_time, duration_time, duartion_hours_minutes_array, attendees)
    return preferences
end

# Time Complexity: O(1)
# Space Complexity: O(?)
# Properly breaks up event based on the Date/Start Time/Duration given.
def breakup_event(duration, start_time)
    sixty_minutes = 60
    duration_hours_in_minutes = duration[0].to_i * sixty_minutes
    five_hours_in_minutes = 300

    if duration_hours_in_minutes < five_hours_in_minutes
        return nil
    end
    duration_hours = duration[0]


    minutes = 60
    seconds = 60
    opening_session_start_time = start_time
    opening_session_end_time = (opening_session_start_time + (minutes * seconds))

    six_hours = 6.0
    meals_take_place_every = six_hours
    meal_events_needed = (duration_hours.to_f)/meals_take_place_every

    duration_hours = duration[0].to_i
    if meal_events_needed  <= 1.0
        time_needed_for_opening_session = 1
        time_needed_for_closing_session = 3
        time_allocated_for_other_activities = duration_hours - (time_needed_for_opening_session + time_needed_for_closing_session)

        group_work_start_time = opening_session_end_time
        group_work_end_time = group_work_start_time + (time_allocated_for_other_activities + (minutes * seconds))

        closing_session_start_time = group_work_end_time
        closing_session_end_time = closing_session_start_time + ((time_needed_for_closing_session) + (minutes * seconds))

        time_slot_hash = {
            opening_session_time_slot: [opening_session_start_time, opening_session_end_time],
            group_work_time_slot: [group_work_start_time, group_work_end_time],
            closing_session_time_slot: [closing_session_start_time, closing_session_end_time],
        }

        return time_slot_hash

    else
        time_needed_for_opening_session = 1
        time_needed_for_closing_session = 3
        time_allocated_for_other_activities = duration_hours - (time_needed_for_opening_session + time_needed_for_closing_session)

        number_of_meal_events_to_account_for = meal_events_needed.floor()
        time_allocated_for_other_activities -= number_of_meal_events_to_account_for

        group_work_durations = (time_allocated_for_other_activities.to_f / number_of_meal_events_to_account_for).ceil()
        number_of_group_work_sessions_to_account_for = (time_allocated_for_other_activities.to_f / group_work_durations).ceil()

        group_work_sessions_time_slots_array = []
        meals_time_slots_array = []
        upcoming_group_work_session_start_time = opening_session_end_time
        closing_session_start_time = nil

        while (number_of_group_work_sessions_to_account_for != 0) or (number_of_meal_events_to_account_for != 0)
            if  number_of_group_work_sessions_to_account_for != 0
                if time_allocated_for_other_activities < group_work_durations
                    group_work_durations = time_allocated_for_other_activities
                end

                upcoming_group_work_session_end_time =  upcoming_group_work_session_start_time + (group_work_durations * (minutes * seconds))

                number_of_group_work_sessions_to_account_for -= 1

                group_work_sessions_time_slots_array.push([
                    upcoming_group_work_session_start_time,
                    upcoming_group_work_session_end_time
                ])

                closing_session_start_time = upcoming_group_work_session_end_time
                time_allocated_for_other_activities -= group_work_durations
            end

            if number_of_meal_events_to_account_for != 0
                upcoming_meal_event_start_time = upcoming_group_work_session_end_time
                upcoming_meal_event_end_time = upcoming_meal_event_start_time + (minutes * seconds)
                number_of_meal_events_to_account_for -= 1

                meals_time_slots_array.push([
                    upcoming_meal_event_start_time,
                    upcoming_meal_event_end_time
                ])


                upcoming_group_work_session_start_time = upcoming_meal_event_end_time
                closing_session_start_time = upcoming_meal_event_end_time
            end
        end

        closing_session_end_time = closing_session_start_time + (time_needed_for_closing_session * (minutes * seconds))

        time_slot_hash = {
            opening_session_time_slot: [opening_session_start_time, opening_session_end_time],
            group_work_time_slots: group_work_sessions_time_slots_array,
            meals_time_slots: meals_time_slots_array,
            closing_session_time_slot: [closing_session_start_time, closing_session_end_time]
        }

        return time_slot_hash
    end
end

# Time Complexity: O(n * m) where n is the number of buildings and m is the number of rooms.
# Space Complexity: O(?)
# Find a room that can fit all attendees.
def find_room_for_all(campus_object, total_attendees, session_array, event_type)
    buildings_on_campus = campus_object.get_hash_of_buildings
    buildings_on_campus.each do |building, building_object|
        rooms_in_bulding = building_object.get_hash_of_rooms
        rooms_in_bulding.each do |room_number, room_object|
            reservation_times_for_room = room_object.get_room_attribute("Reservation Time Slots")
            if time_slot_is_valid(reservation_times_for_room, session_array[0]) and time_slot_is_valid(reservation_times_for_room, session_array[1])
                if room_object.get_room_attribute("Capacity").to_i >= total_attendees
                    opening_session_room_details_array = [
                        building,
                        room_number,
                        room_object,
                        session_array,
                        event_type
                    ]
                    return opening_session_room_details_array
                end
            end
        end
    end
    return nil
end

# Time Complexity: O(n * m * l) where n is the number of buildings, m is the number of rooms, and l is the length of the arrOfMealTimes array.
# Space Complexity: O(?)
# Finds a room that can fits the meal room constraints.
def find_meal_rooms(campus_object, meal_attendees, meal_time_slots, event_type)
    meal_rooms_array = []
    buildings_on_campus = campus_object.get_hash_of_buildings
    buildings_on_campus.each do |building, building_object|

        rooms_in_bulding = building_object.get_hash_of_rooms

        rooms_in_bulding.each do |room_number, room_object|
            next unless room_object.get_room_attribute("Food Allowed").downcase == "yes"
            current_meal_slot = meal_time_slots[0]
            reservation_times_for_room = room_object.get_room_attribute("Reservation Time Slots")

            next unless time_slot_is_valid(reservation_times_for_room, current_meal_slot[0]) == true and time_slot_is_valid(reservation_times_for_room, current_meal_slot[1]) == true
            if room_object.get_room_attribute("Capacity").to_i >= meal_attendees
                meal_rooms_array.push([
                    building,
                    room_number,
                    room_object,
                    current_meal_slot,
                    event_type
                ])
                meal_time_slots.shift
                return meal_rooms_array if meal_time_slots.length == 0
            end
        end
    end
    return nil
end

# Time Complexity: O(n * m * l) where n is the number of buildings, m is the number of rooms, and l is the length of the arrOfHackTimes array.
# Space Complexity: O(?)
# Find a room where participants without computers can hack in.
def find_group_work_rooms(campus_object, computers_needed, group_work_time_slots, event_type)
    group_work_rooms_array = []
    buildings_on_campus = campus_object.get_hash_of_buildings
    loop_status = true
    while loop_status
        current_group_work_slot = group_work_time_slots[0]
        buildings_on_campus.each do |building, building_object|
            rooms_in_bulding = building_object.get_hash_of_rooms
            current_capacity = 0
            enough_rooms_found = false
            valid_rooms = []
            rooms_in_bulding.each do |room_number, room_object|
                next unless room_object.get_room_attribute("Computers Available").downcase == "yes"
                reservation_times_for_room = room_object.get_room_attribute("Reservation Time Slots")
                next unless time_slot_is_valid(reservation_times_for_room, current_group_work_slot[0]) == true and time_slot_is_valid(reservation_times_for_room, current_group_work_slot[1]) == true
                current_capacity += room_object.get_room_attribute("Capacity").to_i
                valid_rooms.push([
                    building,
                    room_number,
                    room_object,
                    current_group_work_slot,
                    event_type
                ])
                if current_capacity >= computers_needed
                    group_work_rooms_array.push(valid_rooms)
                    enough_rooms_found = true
                    group_work_time_slots.shift
                    return group_work_rooms_array if group_work_time_slots.length == 0
                    break
                end
            end
            if enough_rooms_found == true
                break
            end
        end
    end

    return nil
end

# Time Complexity: O(n * m * l) where n is the number of buildings, m is the number of rooms, and l is the length of the arrOfMealTimes/arrOfHackTimes array.
# Space Complexity: O(?)
# Plans the event based on the user preferences.
def schedule(user_preferences, campus_object)
    total_attendees = user_preferences.get_attendees
    meal_attendees = (total_attendees * 0.6).ceil
    computers_needed = (total_attendees * 0.1).ceil

    event_types = [
        "Opening Session",
        "Group Work",
        "Meal",
        "Closing Session",
    ]

    time_slot_hash_for_event = breakup_event(user_preferences.get_duartion_hours_minutes_array, user_preferences.get_start_time)
    if time_slot_hash_for_event == nil
        print "Cannot generate schedule!\n"
        exit
    end

    opening_session_time_slot_array = time_slot_hash_for_event[:opening_session_time_slot]
    closing_session_time_slot_array = time_slot_hash_for_event[:closing_session_time_slot]
    group_work_time_slot_array = time_slot_hash_for_event[:group_work_time_slots]

    opening_room_details_array = find_room_for_all(campus_object, total_attendees, opening_session_time_slot_array, event_types[0])
    if opening_room_details_array == nil
        print "Cannot generate schedule! No room matches opening room constraints!\n"
        exit
    end


    closing_room_details_array = find_room_for_all(campus_object, total_attendees, closing_session_time_slot_array, event_types[3])
    if closing_room_details_array == nil
        print "Cannot generate schedule! No room matches closing room constraints!\n"
        exit
    end

    group_work_details_array = find_group_work_rooms(campus_object, computers_needed, group_work_time_slot_array, event_types[1])
    if group_work_details_array == nil
        print "Cannot generate schedule! No room matches hack room constraints!\n"
        exit
    end

    schedule_hash = {
        opening: opening_room_details_array,
        closing: closing_room_details_array,
        group_work: group_work_details_array,
    }
    if time_slot_hash_for_event.has_key?(:meals_time_slots) == true
        meal_time_slot_array = time_slot_hash_for_event[:meals_time_slots]
        meal_details_array = find_meal_rooms(campus_object, meal_attendees, meal_time_slot_array, event_types[2])
        if meal_details_array == nil
            print "Cannot generate schedule! No room matches meal room constraints!\n"
            exit
        end
        schedule_hash[:meals] = meal_details_array
    end

    return schedule_hash
end
