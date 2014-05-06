class TripsCoordinatesController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token
  	#controller responsible for managing uploads from mobile devices

	def new_trip
=begin
    if not user_signed_in?
			render :json => {response:'auth token not accepted', status:'fail'}
      return
		end
=end

		#information = request.raw_post
		#data_parsed = JSON.parse(information)
		json = JSON.parse(request.body.read())
		#puts 'JSON ' + json
		new_trip = json["trip"]


		#properly prints out the arguments
		#render :json => {status: 'success', submitted_content:json, new_trip:new_trip} 
		trip = Trip.new(new_trip)
		if trip.save
			render :json => {status: 'success', new_trip:trip}
		else
			render :json => {status: 'failure', posted_content:trip}
		end
	end

	def delete_trip
		trip = Trip.find(params[:id])

		trip.destroy
		respond_to do |format|
    		format.html { redirect_to trips_path }
    		format.json { render :json => {status: 'success', response: 'successfully deleted trip'}}
  	end
	end
end

=begin

Posting a sample trip:
to url: http://localhost:3000/upload
via: post
with headers: Accept:application/json
Include this in the body.
{
    "trip": {
        "name": "upload_trip2",
        "time_stamp": "2014-03-12T19:16:29.749Z",
        "distance": 2.04,
        "duration": 2,
        "score": 43,
        "created_at": "2014-03-12T17:50:17.566Z",
        "updated_at": "2014-03-12T19:16:29.754Z",
        "user_id": 1,
        "coordinates_attributes": [
            {
                "latitude": 43,
                "longitude": -89
            },
            {
                "latitude": 43.0001,
                "longitude": -89.0001
            },
            {
                "latitude": 43.0002,
                "longitude": -89.0002
            }
        ]
    }
}



=end