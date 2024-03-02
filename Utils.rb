require 'csv'
require 'date'
require 'time'
require "colorize"

# Time Complexity: O(n)
# Checks if time input given by user is in the PM or not.
def in_pm(hour_period)
  return hour_period.downcase == "pm"
end

# Time Complexity: O(1)
# Convert a String Array to a Date object.
def convert_string_array_to_date(date_array)
  year = date_array[0].to_i
  month = date_array[1].to_i
  day = date_array[2].to_i
  if ((year != 2024) or ((day < 1) or (day > 31)) or ((month < 1) or (month > 12)))
    return false
  end

  begin
      the_date = Date.new(year, month, day)
  rescue
      return false
  end
  return the_date

end

# Time Complexity: O(n)
# Converts a String Array to a Time object.
def convert_string_array_to_time(year, month, day, time_array)
  if in_pm(time_array[1]) == true
      hours = (time_array[0].split(":")[0].to_i + 12)
      hours = (hours == 24) ? 12 : hours
      minutes = time_array[0].split(":")[1].to_i
      time = Time.new(year.to_i, month.to_i, day.to_i, hours, minutes, 0)
  else
      hours = (time_array[0].split(":")[0].to_i)
      hours = (hours == 12) ? 0 : hours
      minutes = time_array[0].split(":")[1].to_i
      time = Time.new(year.to_i, month.to_i, day.to_i, hours, minutes, 0)
  end
  return time
end

# Time Complexity: O(n)
# Converts a String Array to a Time object (Modified for the duration attribute).
def convert_string_array_to_time_duration(start_time, duration_array)
  time = start_time
  minutes = 60
  second = 60
  time += (duration_array[0].to_i * minutes * second)
  time += (duration_array[1].to_i * second)
  return time
end

# Time Complexity: O(n)
# Space Complexity: O(1)
# Read Columns of CSV
def read_attributes(file_name)
  file = CSV.read(Dir.getwd + "/" + file_name)
  attributes = file[0]
  return attributes
end

# Time Complexity: O(n * m * l) where n is the number of seesion in which attendees are hacking, m is the number of rooms assigned to the hacking attendees, and l is the length of output CSV attributes.
# Format the schedule hash map so it can be properly written to a CSV.
def format_for_output_csv(schedule_hash, attributes)
  formatted_schedule = []
  opening = schedule_hash[:opening]
  closing = schedule_hash[:closing]
  group_work = schedule_hash[:group_work]
  opening_row = []
  closing_row = []
  group_work_rows = []
  print attributes
  puts
  puts

  year = opening[3][0].year.to_i
  month = opening[3][0].month.to_i
  day = opening[3][0].day.to_i

  date_format = Date.new(year, month, day)
  opening_row.push(date_format)

  time = opening[3][0]
  opening_row.push(time)

  building = opening[0]
  opening_row.push(building)

  room = opening[1]
  opening_row.push(room)


  for attribute in 0 .. attributes.length-2
      the_attribute = attributes[attribute]
      opening_row.push(opening[2].get_room_attribute(the_attribute))
  end

  purpose = opening[4]
  opening_row.push(purpose)

  year = closing[3][0].year.to_i
  month = closing[3][0].month.to_i
  day = closing[3][0].day.to_i

  date_format = Date.new(year, month, day)
  closing_row.push(date_format)

  time = closing[3][0]
  closing_row.push(time)

  building = closing[0]
  closing_row.push(building)

  room = closing[1]
  closing_row.push(room)

  for attribute in 0 .. attributes.length-2
      the_attribute = attributes[attribute]
      closing_row.push(closing[2].get_room_attribute(the_attribute))
  end

  purpose = closing[4]
  closing_row.push(purpose)

  list_of_group_work_sessions_start = 0
  list_of_group_work_sessions_end = group_work.length-1

  for group_work_session in list_of_group_work_sessions_start .. list_of_group_work_sessions_end
      rooms_for_current_session = []
      list_of_rooms_start = 0
      list_of_rooms_end = group_work[group_work_session].length-1

      for room in list_of_rooms_start .. list_of_rooms_end
          current_room = []

          year = group_work[group_work_session][room][3][0].year.to_i
          month = group_work[group_work_session][room][3][0].month.to_i
          day = group_work[group_work_session][room][3][0].day.to_i

          date_format = Date.new(year, month, day)
          current_room.push(date_format)

          time = group_work[group_work_session][room][3][0]
          current_room.push(time)

          building = group_work[group_work_session][room][0]
          current_room.push(building)

          the_room =  group_work[group_work_session][room][1]
          current_room.push(the_room)

          start_of_attributes = 0
          end_of_attributes = attributes.length-2
          for attribute in start_of_attributes .. end_of_attributes
              the_attribute = attributes[attribute]
              current_room.push(group_work[group_work_session][room][2].get_room_attribute(the_attribute))
          end

          purpose = group_work[group_work_session][room][4]
          current_room.push(purpose)
          rooms_for_current_session.push(current_room)
      end
      group_work_rows.push(rooms_for_current_session)
  end


  formatted_schedule = [opening_row, closing_row, group_work_rows]

  if schedule_hash.has_key?(:meals) == true
      meals = schedule_hash[:meals]
      meals_rows = []


      list_of_meal_sessions_start = 0
      list_of_meal_sessions_end = meals.length-1
      for meals_session in list_of_group_work_sessions_start .. list_of_group_work_sessions_end
              room_for_current_session = []

              year = meals[meals_session][3][0].year.to_i
              month = meals[meals_session][3][0].month.to_i
              day = meals[meals_session][3][0].day.to_i

              date_format = Date.new(year, month, day)
              room_for_current_session.push(date_format)

              time = meals[meals_session][3][0]
              room_for_current_session.push(time)

              building = meals[meals_session][0]
              room_for_current_session.push(building)

              room =  meals[meals_session][1]
              room_for_current_session.push(room)

              for attribute in 0 .. attributes.length-2
                  the_attribute = attributes[attribute]
                  room_for_current_session.push(meals[meals_session][2].get_room_attribute(the_attribute))
              end

              purpose = meals[meals_session][4]
              room_for_current_session.push(purpose)

          meals_rows.push(room_for_current_session)
      end

      formatted_schedule = [opening_row, closing_row, group_work_rows, meals_rows]
  end
  formatted_schedule = format_helper(formatted_schedule)
  formatted_schedule = sort_times(formatted_schedule)
  return formatted_schedule
end

def format_helper(formatted_schedule)
  csv_rows = []

  for purpose in 0 .. formatted_schedule.length - 1
    if purpose < 2
      csv_rows.push(formatted_schedule[purpose])
    elsif purpose == 2
      for group_work_session in 0 .. formatted_schedule[purpose].length - 1
        for rooms in 0 .. formatted_schedule[purpose][group_work_session].length - 1
          csv_rows.push(formatted_schedule[purpose][group_work_session][rooms])
        end
      end
    else
      for room_for_meal_session in 0 .. formatted_schedule[purpose].length-1
        csv_rows.push(formatted_schedule[purpose][room_for_meal_session])
      end
    end
  end
  return csv_rows
end

# Time Complexity: O(n * m)
# Sort the schedule sections by time from earliest to latest.
def sort_times(formatted_schedule_array)
  loop do
      for element in 0 .. formatted_schedule_array.length - 2
          time_element_1 = formatted_schedule_array[element][1]
          time_element_2 = formatted_schedule_array[element + 1][1]
          if  time_element_1 > time_element_2
              formatted_schedule_array[element], formatted_schedule_array[element + 1] = formatted_schedule_array[element + 1], formatted_schedule_array[element]
              swapped = true
          end
      end
      break if not swapped
  end
  return formatted_schedule_array
end

def make_output_csv_attributes1(attributes)
  attributes.shift
  attributes.shift
  attributes.push("Purpose")
  return attributes
end

def make_output_csv_attributes2(attributes)
  attributes.unshift("Room")
  attributes.unshift("Building")
  attributes.unshift("Time")
  attributes.unshift("Date")
end

def print_schedule(attributes, schedule)
  print "\nHere is your generated schedule:\n"

  for attribute in 0 .. attributes.length-1
    if attribute == 0
      print attributes[attribute]
    else
      print ", " + attributes[attribute]
    end
  end
  print "\n"
  schedule_start = 0
  schedule_end = schedule.length - 1

  for row in schedule_start .. schedule_end
    for element in 0 .. schedule[row].length - 1
      end_of_row = schedule[row].length - 1
      if schedule[row][end_of_row] == "Opening Session"
        if element > 0
          print ", ".colorize(:yellow)
        end
        print schedule[row][element].to_s.colorize(:yellow)
      elsif schedule[row][end_of_row] == "Group Work"
        if element > 0
          print ", ".colorize(:blue)
        end
        print schedule[row][element].to_s.colorize(:blue)
      elsif schedule[row][end_of_row] == "Meal"
        if element > 0
          print ", ".colorize(:red)
        end
        print schedule[row][element].to_s.colorize(:red)
      else
        if element > 0
          print ", ".colorize(:green)
        end
        print schedule[row][element].to_s.colorize(:green)
      end
    end
    puts
  end
end

# Time Complexity: O(n)
# Prompts user with the option to save the schedule generated for them.
def prompt_file_save(output_attributes, schedule_csv)
  print "\nWould you like to save the schedule as a CSV? Enter 'Y' for Yes or 'N' for No: "
    while true
        response = gets.chomp()
        if response.downcase == "y"
            print "\n"
            print "What would you like to name the file? (End file name with \".csv\"): "
            while
                name = gets.chomp()
                if name.end_with?(".csv") == true
                    CSV.open(name, "w") do |csv|
                        csv << output_attributes
                        for element in 0 .. schedule_csv.length-1
                            csv << schedule_csv[element]
                        end
                    end
                    curr_directory = Dir.getwd
                    print "\n\"" + name + "\" has been saved to " + curr_directory + "\n"
                    exit
                else
                    print "\nFile name entered did not end with \".csv\"\nPlease try again.\n\n"
                    print "What would you like to name the file? (End file name with \".csv\"): "
                end
            end
        elsif response.downcase == "n"
            exit
        else
            "\nResponse not understood.\nIf you would like to save the schedule as a CSV, enter 'Y' for Yes or 'N' for No: "
        end
    end
end
