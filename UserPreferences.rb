class UserPreferences
  def initialize(evD, stT, dur, att)
    @eventDate = evD
    @startTime = stT
    @duration = dur
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

  def getAttendees
    @attendees
  end

  def addToDuration(num)
    @duration = @duration + num
  end
end
