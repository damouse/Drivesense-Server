class TripViewerController < ApplicationController
	before_action :authenticate_user!

  def all_trips
  	@trips = current_user.trips
  end

  def trip_viewer
  	@trip = Trip.find(params[:id])

    contains = false
    current_user.trips.each do |trip|
      contains = true if trip.id == @trip.id
    end

    unless contains
      redirect_to invalid_trip_path
    end

  	@coordinates = @trip.coordinates
  	@hash = Gmaps4rails.build_markers(@coordinates) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
      marker.title 'hallo'
    end
  end

  def invalid_trip

  end
end
