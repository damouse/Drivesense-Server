class AccountController < ApplicationController
	skip_before_filter :verify_authenticity_token #this may be dangerous, check

	#check logins here
	def sess
		if user_signed_in?
			render :json => {response:'accepted auth token', status:'success'}
		else
			render :json => {response:'auth token not accepted', status:'fail'}
		end
	end

	#endpoint for logging in from a mobile app
	#CURRENTLY INSECURE
	def mobile_login
		email = params[:user_email]
		pass = params[:password]

		if not email.present? or not pass.present?
			render :json => {response:'missing parameters', status:'fail'}
		else
			user = User.find_by_email(email)

			if not user
				render :json => {response:'user not found', status:'fail'}
			else
				user.ensure_authentication_token
				render :json => {response:'user logged in',status:'success', user:user}
			end
		end
	end
end


=begin
  For test@test.com/12345678, use the following URL to get access:
  /sess?user_email=test@test.com&user_token=UiMpEYVmusxnJfKvHsSk
  
	And this one to retrieve the auth token for any user (currently insecure)
	http://localhost:3000/mobile_login?password=12345678&user_email=test%40test.com
=end