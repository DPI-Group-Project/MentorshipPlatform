Rails.application.routes.draw do
  resources :meetings
  resources :cohort_members
  resources :organizations
  resources :reviews
  resources :matches
  resources :cohorts
  resources :programs
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get 'signup', to: 'users/registrations#signup'
  end


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
end
