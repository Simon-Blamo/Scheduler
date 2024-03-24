require './Room.rb'

# Entity Class that represents the buildings within problem domain.
class Building

  # Field that stores data about a specific building.
  # Field is a hash, with the room numbers being the key, and value being the room object.
  @hash_of_rooms = nil

  # Constructor
  def initialize()
    @hash_of_rooms = {}
  end

  # Getter that retrieves a room object based on room number.
  def get_room(room_number)
    room_object = @hash_of_rooms[room_number]
    return room_object
  end

  # Boolean method that determines if room exists within a building
  def has_room?(room_number)
    result = @hash_of_rooms.has_key?(room_number)
    return result
  end

  # Setter that updates room object in the hash.
  def set_room(room_object)
    temp_hash = @hash_of_rooms
    room_number = room_object.get_room_attribute("Room")
    temp_hash[room_number] = room_object
    @hash_of_rooms = temp_hash
  end

  # Methods that delete a room within the hash based on room given.
  def delete_room(room_number)
    @hash_of_rooms.delete(room_number)
  end

  # Getter that returns the hash map field within building class.
  def get_hash_of_rooms
    return @hash_of_rooms
  end
end
