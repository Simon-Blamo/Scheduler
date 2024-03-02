require './Building'

# Entity Class that represents a campus within problem domain.
class Campus

  # Field that stores data about buildings that are located on the campus.
  # Field is a hash, with the building name as the key, and value being the corresponding building object.
  @hash_of_buildings = nil

  # Constructor
  def initialize()
    @hash_of_buildings = {}
  end

  # Getter that retrieves a specific building
  def get_building(building_name)
    return @hash_of_buildings[building_name]
  end

  # Setter that updates a specific building
  def update_building(building_name, building_object)
    @hash_of_buildings[building_name] = building_object
  end

  # Void methods that configures campus object
  def populate_building_hash_key(file_name)
    file = CSV.read(Dir.getwd + "/" + file_name)
    for row in 1 .. file.length-1
      building = file[row][0]
      @hash_of_buildings[building] = nil
    end
  end

  # Getter that retrieves the hash map of building on the campus.
  def get_hash_of_buildings
    return @hash_of_buildings
  end
end
