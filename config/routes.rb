Rails.application.routes.draw do
  root "top#index"
  get "/home", to: "home#index"
  resources :breads, only: [:index]

  # Devise導入時に消す予定
  get "signup", to: "pages#signup"
  get "login",  to: "pages#login"

  #ヘルスチェックエンドポイント
  get "up" => "rails/health#show", as: :rails_health_check
end
