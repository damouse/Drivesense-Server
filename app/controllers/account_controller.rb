class AccountController < ApplicationController
	skip_before_filter :verify_authenticity_token #this may be dangerous, check

	#check logins here
	#sample: /sess?user_email=test@test.com&user_token=UiMpEYVmusxnJfKvHsSk
	def sess
		if user_signed_in?
			render :json => {response:'accepted auth token'}, :status => :accepted
		else
			render :json => {response:'auth token not accepted'}, :status => :bad_request
		end
	end

	#endpoint for logging in from a mobile app
	#CURRENTLY INSECURE
	#sample: /mobile_login?password=12345678&user_email=test%40test.com
	def mobile_login
		email = params[:user_email]
		pass = params[:password]

		if not email.present? or not pass.present?
			render :json => {response:'missing parameters'}, :status => :bad_request and return
    end

		user = User.find_by_email(email)

		if user.nil?
      render :json => {response:'user not found'}, :status => :bad_request and return 
    end

    if not user.valid_password?(pass)
      render :json => {response:'wrong password'}, :status => :bad_request and return 
    end

		user.ensure_authentication_token
		render :json => user, :status => :accepted

	end

	#create a new user with the passed user object
	def register_user
		json = JSON.parse(request.body.read())

		email = json["user_email"]
		pass = json["password"]

    if not email.present? or not pass.present?
      render :json => {response:'missing parameters'}, :status => :bad_request
      return
    end

    if User.find_by_email(email)
      render :json => {response:'user already exists with that email'}, :status => :bad_request
      return
    end

    user = User.new(email:email, password:pass)

    if user.save
      render :json => user, :status => :created
    else
      render :json => {response:'registration failed', errors:user.errors.full_messages}, :status => :internal_server_error
    end
  end
end


=begin
{
  "response": "user logged in",
  "status": "success",
  "user": {
    "id": 1,
    "email": "test@test.com",
    "created_at": "2014-03-12T17:38:16.775Z",
    "updated_at": "2014-04-29T22:02:46.769Z",
    "authentication_token": "UiMpEYVmusxnJfKvHsSk"
  }
}
=end