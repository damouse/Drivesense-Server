class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user_from_token!

 	def authenticate_user_from_token!
	    user_email = params[:user_email].presence
	    user       = user_email && User.find_by_email(params[:user_email])

	    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
	      sign_in user, store: false
	    end
	end

	def after_sign_in_path_for(user)
	  trips_path
	end

	def after_sign_out_path_for(user)
	  root_path
	end
end
