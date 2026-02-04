Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  root "top#index"
  get "/home", to: "home#index"
  resources :breads, only: [:index]

  # ゲストログイン
  post 'users/guest_sign_in', to: 'users/sessions#guest'

  # ヘルスチェックエンドポイント
  get "up" => "rails/health#show", as: :rails_health_check
end
