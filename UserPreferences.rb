class UserPreferences
  def initialize(event_date, start_time, duration, duartion_hours_minutes_array, attendees)
    @event_date = event_date
    @start_time = start_time
    @duration = duration
    @duartion_hours_minutes_array = duartion_hours_minutes_array
    @attendees = attendees
  end

  # getters
  def get_event_date
    @event_date
  end

  def get_start_time
    @start_time
  end

  def get_duration
    @duration
  end

  def get_duartion_hours_minutes_array
    @duartion_hours_minutes_array
  end

  def get_attendees
    @attendees
  end

end
