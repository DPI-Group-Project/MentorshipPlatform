Rails.application.routes.draw do
  resources :meetings
  resources :cohort_members do
    # Collection routes for adding and deleting emails without a specific cohort_member ID
    post :add_email, on: :collection, as: :add_email
    post :delete_email, on: :collection, as: :delete_email
  end
  resources :organizations
  resources :reviews
  resources :matches
  resources :cohorts
  resources :programs
  devise_for :users, controllers: { registrations: 'users/registrations' }
 

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get 'signup', to: 'users/registrations#signup', as: :mentor_mentee_registration
    post 'update_shortlist', to: 'users/registrations#update_shortlist', as: :update_shortlist
  end


  # Reveal health status on /up that returns 200 if the aboots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  get '/dashboard/:role/:program_id', to: 'dashboard#show'
  get '/dashboard/:role', to: 'dashboard#show', as: :dashboard
  get '/profile/:id', to: 'profile#show', as: :profile

  post '/profile/:id/create_request', to: 'profile#create', as: 'create_request_profile'


  # Defines the root path route ("/")
  root 'home#index', as: :home
end
