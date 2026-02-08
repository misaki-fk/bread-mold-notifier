Rails.application.routes.draw do
  if Rails.env.development?
   require "letter_opener_web"
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users, controllers: { sessions: 'users/sessions' }
  root "top#index"
  get "/home", to: "home#index"
  
  resources :breads, only: [:new, :create, :destroy]

  post 'users/guest_sign_in', to: 'users/sessions#guest'
  get "up" => "rails/health#show", as: :rails_health_check
end