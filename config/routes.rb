Rails.application.routes.draw do

  resources :groups

  get 'trips_coordinates/new_trip'

  devise_for :users
  root 'public#landing'

  #account
  match '/sess', to: 'account#sess', via: 'get'
  match '/mobile_login', to: 'account#mobile_login', via: 'get'
  match '/mobile_register', to: 'account#register_user', via: 'post'
  match '/register', to: 'account#register_user', via: 'post'
  match '/account', to: 'account#account', via: 'get'

  match '/news', to: 'public#news', via: 'get'
  match '/about', to: 'public#about', via: 'get'

  match '/trips', to: 'manage_trips#manage_trips', via: 'get'

  match '/upload', to: 'trips_coordinates#new_trip', via: 'post'
  match '/delete_trip/:id', to: 'trips_coordinates#delete_trip', via: 'get'
  match '/invalid_trip', to: 'trip_viewer#invalid_trip', via: 'get'
  match '/invite', to: 'groups#invite', via: 'post'
  match '/accept', to: 'groups#accept', via: 'get'
  match '/decline', to: 'groups#decline', via: 'get'
  match '/remove/:id', to: 'groups#remove', via: 'get'
  match '/stats/:id', to: 'groups#stats', via: 'get'

  #ajax tripviewer calls
  match '/trips_range', to: 'trip_viewer#trips_range', via: 'get'
  match '/trips_information', to: 'trip_viewer#trips_information', via: 'get'
  
end
