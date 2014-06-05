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

  	@coordinates = @trip.coordinates.sort_by &:time_stamp
  	@endpoints = [@coordinates.first, @coordinates.last]
  	
  	@hash = Gmaps4rails.build_markers(@endpoints) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
      marker.title "hi"
      
    end
    
    @polylines = Gmaps4rails.build_markers(@coordinates) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
    end    
    
  end
  

  def invalid_trip

  end
end
