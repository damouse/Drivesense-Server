class TripsCoordinatesController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user_from_token!


	def new_trip
    return unless ensure_logged_in

    body = request.body.read()
		json = JSON.parse(body)

		new_trip = json["trip"]
    user_id = json['user']['id']

		#properly prints out the arguments
		trip = Trip.new(new_trip)
    trip.user_id = user_id
    # render json: trip.as_json(include: {coordinates: {}, score: {include: :patterns}}) and return

		if trip.save
			render :json => trip, :status => :accepted
      CallHistory.create(json:body)
		else
			render :json => {errors: trip.errors}, :status => :bad_request
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
      render :json => {response:'auth token not accepted'}, :status => :bad_request
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
    if user && Devise.secure_compare(user.authentication_token, user_json["authentication_token"])
      sign_in user, store: false
    end
  end
end
