class TripsController < ApplicationController
	before_action :authenticate_user!

  def all_trips
  	@trips = current_user.trips
  end

  def trip_viewer
  end
end
