class Trip < ActiveRecord::Base
	has_many :coordinates, :dependent => :delete_all
	belongs_to :user
  has_one :score, :dependent => :destroy

	accepts_nested_attributes_for :coordinates, :score
  validates :time_stamp, presence: true
  validates :coordinates, presence: true

  #build the endpoint coordinates required by gmaps
  def gmaps_endpoints
    coordinates = self.coordinates.sort_by &:time_stamp
    endpoints = [coordinates.first, coordinates.last]

    
    count = 0
    hash = Gmaps4rails.build_markers(endpoints) do |coord, marker|
      time = Time.at(coord.time_stamp/1000)
      marker.lat coord.latitude
      marker.lng coord.longitude
      if count == 0
        marker.infowindow "Start of Trip (#{time.strftime('%r')})"
        marker.picture({
          :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=S|00FF00|000000",
          :width   => 20,
          :height  => 32
        })
      else
        marker.infowindow "End of Trip (#{time.strftime('%r')})"
        marker.picture({
          :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=F|FF0000|000000",
          :width   => 20,
          :height  => 35
        })
      end

      marker.title time.strftime('%r')
      count += 1
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
