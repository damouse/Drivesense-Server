class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!

 	def authenticate_user_from_token!
	    user_email = params[:user_email].presence
	    user       = user_email && User.find_by_email(user_email)
	 
	    # Notice how we use Devise.secure_compare to compare the token
	    # in the database with the token given in the params, mitigating
	    # timing attacks.
	    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
	      sign_in user, store: false
	    end
	end

	def after_sign_in_path_for(user)
		if user.group.nil?
	  		trips_path
	  	elsif user.group.owner == user
	  		user.group
	  	else
	  		trips_path
	  	end
	end

	def after_sign_out_path_for(user)
	  root_path
	end
end
