class TripsCoordinatesController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user_from_token!


	def new_trip
    return unless ensure_logged_in

		json = JSON.parse(request.body.read())

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

  private
  #check to make sure the auth token is accepted. 
  def ensure_logged_in
    if not user_signed_in?
      render :json => {response:'auth token not accepted', status:'fail'}
      return false
    end

    return true
  end

  def authenticate_user_from_token!
    content = request.body.read()
    return unless content.length > 2

    json = JSON.parse(content)
    user_json = json["user"]

    user_id = user_json["id"].presence
    user = user_id && User.find_by_id(user_id)

 
    #required to reset the read position of the body
    request.body.rewind

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, user_json["auth_token"])
      sign_in user, store: false
    end
  end
end

=begin
Implements API to access trips from a mobile device. 

Requires a valid token and user_id be passed in with every call. 
Format (sample trip upload)
{
  "user": {
    "id":1,
    "auth_token":"2YmMtMRNEXMUyGFrZr9p"
  },
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

=begin
{
    "user": {
        "id": 1,
        "auth_token": "UiMpEYVmusxnJfKvHsSk"
    },
    "trip": {
        "score": 11,
        "coordinate_attributes": [
            {
                "longitude": -89.400559075,
                "latitude": 43.07309978333333
            },
            {
                "longitude": -89.400561225,
                "latitude": 43.07287135
            }
        ],
        "user_id": "1",
        "duration": 11,
        "distance": 0.17346216299890393,
        "time_stamp": 11,
        "name": "Trip #1"
    }
}
=end
