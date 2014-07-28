class TripsCoordinatesController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user_from_token!


	def new_trip
    return unless ensure_logged_in

		json = JSON.parse(request.body.read())

		new_trip = json["trip"]

		#properly prints out the arguments
		#render :json => {status: 'success', submitted_content:json, new_trip:new_trip} and return
        #return
		trip = Trip.new(new_trip)
        trip.time_stamp = Time.at(trip.raw_time_stamp)
        trip.time = TimeOfDay.parse(trip.time_stamp.strftime("%H:%M:%S"))

        #render :json => trip and return

        # if trip.valid?
        #     render :json => {status: 'success', new_trip:trip}
        # else
        #     render :json => {status: 'success', new_trip:trip}
        # end
        if trip.user != current_user
           render :json => {status: 'failed attempt to post(wrong user)', posted_content:trip}
           return
        end

		if trip.save
			render :json => {status: 'success', new_trip:trip}
		else
			render :json => {status: 'failure', posted_content:trip, errors: trip.errors}
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
Upload call with scoring information

USE THIS AUTH KEY FOR HEROKU: 5aSK8iLoEeSzXvr9Pp5d
for user account test@test.com, pw:12345678

fCAnizV-siiCoeKAjpsw
{
    "user": {
        "id": "9",
        "auth_token": "AsPYQbwaxy9FejKxG-8i"
    },
    "trip": {
        "score_attributes": {
            "patterns_attributes": [
                {
                    "pattern_type": "brake",
                    "end_time": 1402527488904,
                    "start_time": 1402527488403,
                    "raw_score": 90.06905634310833
                },
                {
                    "pattern_type": "acceleration",
                    "end_time": 1402527487814,
                    "start_time": 1402527483245,
                    "raw_score": 100
                },
                {
                    "pattern_type": "acceleration",
                    "end_time": 1402527488443,
                    "start_time": 1402527487873,
                    "raw_score": 73.0348957553633
                },
                {
                    "pattern_type": "acceleration",
                    "end_time": 1402527491183,
                    "start_time": 1402527488863,
                    "raw_score": 66.55949155986409
                },
                {
                    "pattern_type": "turn",
                    "end_time": 1402527491100,
                    "start_time": 1402527484100,
                    "raw_score": -1
                }
            ],
            "score": 84,
            "scoreAccels": 79.8648,
            "scoreBreaks": 90.06905,
            "scoreLaneChanges": 100,
            "scoreTurns": 68.66376
        },
        "user_id": "9",
        "duration": 7,
        "distance": 0.11038501669622747,
        "coordinates_attributes": [
            {
                "longitude": -89.39856122500001,
                "latitude": 43.07287135
            },
            {
                "longitude": -89.39856337500001,
                "latitude": 43.072642916666666
            },
            {
                "longitude": -89.39856552500001,
                "latitude": 43.07241448333333
            },
            {
                "longitude": -89.39856767500001,
                "latitude": 43.07218605
            },
            {
                "longitude": -89.39856982500001,
                "latitude": 43.071957616666666
            },
            {
                "longitude": -89.39857197500001,
                "latitude": 43.07172918333333
            },
            {
                "longitude": -89.39857412500001,
                "latitude": 43.07150075
            },
            {
                "longitude": -89.39857627500001,
                "latitude": 43.071272316666665
            }
        ],
        "time_stamp": 7,
        "name": "Trip #12"
    }
}


{
    "user": {
        "id": "1",
        "auth_token": "8DDgf7x4z1sNiUeu81YR"
    },
    "trip": {
        "score_attributes": {
            "patterns_attributes": [
                {
                    "pattern_type": "brake",
                    "end_time": 1402527488904,
                    "start_time": 1402527488403,
                    "raw_score": 90.06905634310833
                },
                {
                    "pattern_type": "acceleration",
                    "end_time": 1402527487814,
                    "start_time": 1402527483245,
                    "raw_score": 100
                },
                {
                    "pattern_type": "acceleration",
                    "end_time": 1402527488443,
                    "start_time": 1402527487873,
                    "raw_score": 73.0348957553633
                },
                {
                    "pattern_type": "acceleration",
                    "end_time": 1402527491183,
                    "start_time": 1402527488863,
                    "raw_score": 66.55949155986409
                },
                {
                    "pattern_type": "turn",
                    "end_time": 1402527491100,
                    "start_time": 1402527484100,
                    "raw_score": -1
                }
            ],
            "score": 84,
            "scoreAccels": 79.8648,
            "scoreBreaks": 90.06905,
            "scoreLaneChanges": 100,
            "scoreTurns": 68.66376
        },
        "user_id": "1",
        "duration": 7,
        "distance": 0.11038501669622747,
        "coordinates_attributes": [
            {
                "longitude": -89.39856122500001,
                "latitude": 43.07287135,
                "time_stamp": "2014-07-13 15:55:16"
            },
            {
                "longitude": -89.39856337500001,
                "latitude": 43.072642916666666,
                "time_stamp": "2014-07-13 15:56:16"
            },
            {
                "longitude": -89.39856552500001,
                "latitude": 43.07241448333333,
                "time_stamp": "2014-07-13 15:57:16"
            },
            {
                "longitude": -89.39856767500001,
                "latitude": 43.07218605,
                "time_stamp": "2014-07-13 15:58:16"
            },
            {
                "longitude": -89.39856982500001,
                "latitude": 43.071957616666666,
                "time_stamp": "2014-07-13 15:59:16"
            },
            {
                "longitude": -89.39857197500001,
                "latitude": 43.07172918333333,
                "time_stamp": "2014-07-13 16:00:16"
            },
            {
                "longitude": -89.39857412500001,
                "latitude": 43.07150075,
                "time_stamp": "2014-07-13 16:01:16"
            },
            {
                "longitude": -89.39857627500001,
                "latitude": 43.071272316666665,
                "time_stamp": "2014-07-13 16:02:16"
            }
        ],
        "time_stamp": "2014-07-13 16:02:16",
        "name": "Trip #1"
    }
}
=end
