class Trip < ActiveRecord::Base
	has_many :coordinates, :dependent => :delete_all
	belongs_to :user
  has_one :score, :dependent => :destroy

	accepts_nested_attributes_for :coordinates, :score
  validates :time_stamp, presence: true

  #build the endpoint coordinates required by gmaps
  def gmaps_endpoints
    coordinates = self.coordinates.sort_by &:time_stamp
    endpoints = [coordinates.first, coordinates.last]
    
    hash = Gmaps4rails.build_markers(endpoints) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude

      unless coord.time_stamp.nil?
        time = Time.at(coord.time_stamp)
        marker.title time.strftime('%r')
      else
        marker.title "End Point"
      end

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

  def pretty_time

  end
end
