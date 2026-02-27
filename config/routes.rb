Rails.application.routes.draw do
  get 'static_pages/terms'
  get 'static_pages/privacy'
  get 'settings/index'
  if Rails.env.development?
   require "letter_opener_web"
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
 
  # 通常ログイン
  devise_for :users, controllers: { sessions: 'users/sessions' }
  
  root "top#index"
  get "/home", to: "home#index"

  resources :breads, only: [:new, :create, :edit, :update, :destroy]

  # ゲストログイン
  devise_scope :user do
    post "guest_sign_in", to: "guest_sessions#create"
  end

  get 'settings', to: 'settings#index'

  resource :default_bread, only: [:new, :create, :edit, :update, :show]
  get "up" => "rails/health#show", as: :rails_health_check
end