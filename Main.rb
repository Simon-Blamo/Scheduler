require "./Scheduler.rb"

# Time Complexity O(n *m *l)
# Controller function that handle class all the core functions of entire program.
def make_schedule()
  array_of_processing_essentials_1 = get_rooms_csv()
  array_of_processing_essentials_2 = get_rooms_reservation_csv()
  room_details_file_name = array_of_processing_essentials_1[0]
  attributes_for_rooms = array_of_processing_essentials_1[1]
  reservation_file_name = array_of_processing_essentials_2[0]
  attributes_for_reservations = array_of_processing_essentials_2[1]

  tcnj = save_room_details(room_details_file_name, attributes_for_rooms)
  tcnj = save_room_reservation_details(reservation_file_name, attributes_for_reservations, tcnj)

  users_preference = get_user_preferences()
  output_attributes = make_output_csv_attributes1(attributes_for_rooms)

  non_csv_formatted_schedule = schedule(users_preference, tcnj)
  csv_formatted_schedule = format_for_output_csv(non_csv_formatted_schedule, output_attributes)
  output_attributes = make_output_csv_attributes2(output_attributes)

  print_schedule(output_attributes, csv_formatted_schedule)
  prompt_file_save(output_attributes, csv_formatted_schedule)
end

make_schedule()
