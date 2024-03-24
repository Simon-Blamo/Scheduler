require 'csv'
require 'date'
require 'time'

# Entity Class that represents the rooms within problem domain.
class Room

  # Field that stores data about a specific room found within CSV.
  # Field is a hash, with the CSV attribute being the key, and value for that attribute being the value.
  @room_hash = nil

  # constructor
  def initialize(room_number)
    @room_hash = {}
    @room_hash["Room"] = room_number
  end

  # Setter that sets room attribute.
  def set_room_attribute(attribute, value)
    temp_hash = @room_hash
    temp_hash[attribute] = value
    @room_hash = temp_hash
  end

  # Getter that retrieve room attribute value.
  def get_room_attribute(attr)
    return @room_hash[attr]
  end

  # Boolean method to test if the room object has a specific key within the hash.
  def room_has_key?(key)
    result = @room_hash.has_key?(key)
    return result
  end
end
