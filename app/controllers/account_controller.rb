class AccountController < ApplicationController
	skip_before_filter :verify_authenticity_token #this may be dangerous, check

	#check logins here
	#sample: /sess?user_email=test@test.com&user_token=UiMpEYVmusxnJfKvHsSk
	def sess
		if user_signed_in?
			render :json => {response:'accepted auth token', status:'success'}
		else
			render :json => {response:'auth token not accepted', status:'fail'}
		end
	end

	#endpoint for logging in from a mobile app
	#CURRENTLY INSECURE
	#sample: /mobile_login?password=12345678&user_email=test%40test.com
	def mobile_login
		email = params[:user_email]
		pass = params[:password]

		if not email.present? or not pass.present?
			render :json => {response:'missing parameters', status:'fail'}
		else
			user = User.find_by_email(email)

			if not user
        return register_user_scratch(email, pass)
				#render :json => {response:'user not found', status:'fail'}
			else
				user.ensure_authentication_token
				render :json => {response:'user logged in',status:'success', user:user}
			end
		end
	end

	#create a new user with the passed user object
	def register_user
		json = JSON.parse(request.body.read())

		email = json["user_email"]
		pass = json["password"]

    if not email.present? or not pass.present?
      render :json => {response:'missing parameters', status:'fail'}
      return
    end

    if User.find_by_email(email)
      render :json => {response:'user already exists with that email', status:'fail'}
      return
    end

    return register_user_scratch(email, pass)
	end

  private

  def register_user_scratch(email, password)
    user = User.new(email:email, password:password)

    if user.save
      render :json => {response:'user created',status:'success', user:user}
    else
      render :json => {response:'registration failed',status:'success', errors:user.errors.full_messages}
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