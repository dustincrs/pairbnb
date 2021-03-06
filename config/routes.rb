Rails.application.routes.draw do
  resources :subscriptions
  resources :chatrooms
  resources :messages
  # Root redirect
  root "welcome#index"

  # Clearance route overrides
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: :users, only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  # Omniauth redirect
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"

	# Resources from rails build
	resources :listing_photos
	resources :avatars
	resources :bookings
	resources :listings
	resources :users
  # resources :taggings NO NEEED RESOURCES TAGGING (NO TAGGING SHIT HAPPENING)
  # resources :tags NO NEED RESOURCES TAGS (NO TAG SHIT HAPPENING)

  # Manual additions
  # update user
  # make path for post to update
  patch "/users/:id" => "users#update", as: "update_user"

  # Verifying Listings
  put "/listings/verify/:id" => "listings#verify", as: "verify_listing"

  # Payments
  get '/payments/:booking_id' => "braintree#show", as: "payments"
  post 'braintree/checkout'

  # Guests
  get '/users/:id/guests' => "users#guests", as: "guests"

  #Searches
  # Filter search
  get '/search/show'

  # Text search
  get '/search/text_search'
  get '/search/text_search_ajax'

  # Mount channels for ActionCable
  mount ActionCable.server, at: '/cable'

	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
