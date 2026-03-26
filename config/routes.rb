Rails.application.routes.draw do
  get 'notifications/index'
  get 'notification_settings/show'
  get 'notification_settings/edit'
  get 'notification_settings/update'
  get 'static_pages/terms'
  get 'static_pages/privacy'
  get 'settings/index'
  if Rails.env.development?
   require "letter_opener_web"
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
 
  # 通常ログイン
  devise_for :users, controllers: { sessions: 'users/sessions',}
  
  root "top#index"
  get "/home", to: "home#index"

  resources :breads, only: [:new, :create, :edit, :update, :destroy] do
    member do
      patch :increase
      patch :decrease
    end
  end

  # ゲストログイン
  devise_scope :user do
    post "guest_sign_in", to: "guest_sessions#create"
  end

  get 'settings', to: 'settings#index'

  resource :default_bread, only: [:new, :create, :edit, :update, :show]

  get 'terms',   to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'

  get "guest/signup_prompt", to: "guest#signup_prompt", as: :guest_signup_prompt
  get "guest/to_signup", to: "guest#to_signup", as: :guest_to_signup
  get "guest/to_login", to: "guest#to_login", as: :guest_to_login

  resource :notification_setting, only: [:show, :edit, :update]

  resources :notifications, only: [:index]

  get "up" => "rails/health#show", as: :rails_health_check

  post "/ocr", to: "ocrs#create"
end