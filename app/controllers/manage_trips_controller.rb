class ManageTripsController < ApplicationController
  before_action :authenticate_user!
  def manage_trips
    gon.current_user = current_user.id 
  end 
end 
