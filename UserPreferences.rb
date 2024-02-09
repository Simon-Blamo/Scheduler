class UserPreferences
  def initialize(evD, stT, dur, dur2, att)
    @eventDate = evD
    @startTime = stT
    @duration = dur
    @duration2 = dur2
    @attendees = att
  end

  # getters
  def getEventDate
    @eventDate
  end

  def getStartTime
    @startTime
  end

  def getDuration
    @duration
  end

  def getDuration2
    @duration2
  end

  def getAttendees
    @attendees
  end

end
