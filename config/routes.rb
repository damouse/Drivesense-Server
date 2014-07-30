Rails.application.routes.draw do

  resources :groups

  get 'trips_coordinates/new_trip'

  devise_for :users
  root 'public#landing'

  #account
  match '/sess', to: 'account#sess', via: 'get'
  match '/mobile_login', to: 'account#mobile_login', via: 'get'
  match '/register', to: 'account#register_user', via: 'post'
  match '/account', to: 'account#account', via: 'get'

  match '/news', to: 'public#news', via: 'get'
  match '/about', to: 'public#about', via: 'get'

  match '/trips', to: 'trip_viewer#all_trips', via: 'get'
  match '/tripviewer/:id', to: 'trip_viewer#trip_viewer', via: 'get', as: 'tripviewer'
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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
