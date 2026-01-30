Rails.application.routes.draw do
  devise_for :users
  root "top#index"
  get "/home", to: "home#index"
  resources :breads, only: [:index]

  #ヘルスチェックエンドポイント
  get "up" => "rails/health#show", as: :rails_health_check
end
