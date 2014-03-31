class TripViewerController < ApplicationController
	before_action :authenticate_user!

  def all_trips
  	@trips = current_user.trips
  end

  def trip_viewer
  	@trip = Trip.find(params[:id])
  	@coordinates = @trip.coordinates
  	@hash = Gmaps4rails.build_markers(@coordinates) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
      marker.title 'hallo'
    end
  end
end
