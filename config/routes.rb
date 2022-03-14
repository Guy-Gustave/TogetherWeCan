Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  resources :capitals, only: [:index, :create]
  resources :transactions, only: [:index, :create]
  resources :purchases, only: [:index]
  resources :gifts, only: [:index]
  resources :savings, only: [:index]

  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  post :payment, to: "transactions#create_gift_payment"
  post :capitals_generation, to: "transactions#create_next_capitals"

  root to: 'transactions#index'
end
