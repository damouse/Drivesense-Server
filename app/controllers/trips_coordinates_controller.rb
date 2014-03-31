class TripsCoordinatesController < ApplicationController
	before_filter :check_format


	  
  	#controller responsible for managing uploads from mobile devices
  	
  	def new_trip
  	end

  	#respond only to JSON
  	def check_format
	    render :nothing => true, :status => 404 unless params[:format] == 'json'
	end
end
