class TripsController < ApplicationController
	before_action :authenticate_user!

  def all_trips
  end

  def trip_viewer
  end
end
