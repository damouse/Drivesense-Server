class Trip < ActiveRecord::Base
	has_many :coordinates, :dependent => :delete_all
	belongs_to :user
    has_one :score, :dependent => :destroy
	accepts_nested_attributes_for :coordinates, :score

  #build the endpoint coordinates required by gmaps
  def gmaps_endpoints
    coordinates = self.coordinates.sort_by &:time_stamp
    endpoints = [coordinates.first, coordinates.last]
    
    hash = Gmaps4rails.build_markers(endpoints) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
      marker.title "hi"
    end

    hash.to_json
  end

  def gmaps_coordinates
    coordinates = self.coordinates.sort_by &:time_stamp

    polylines = Gmaps4rails.build_markers(coordinates) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
    end 

    polylines.to_json
  end
end
