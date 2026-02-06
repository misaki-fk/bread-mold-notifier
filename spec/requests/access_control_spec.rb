require 'rails_helper'

RSpec.describe 'アクセス制御', type: :request do
  let(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  context '未ログイン時' do
    it 'ホーム画面は閲覧できる' do
      get home_path
      expect(response).to have_http_status(:ok)
    end
  end

  context 'ログイン後' do
    before { sign_in user }

    it 'ホーム画面にアクセスできる' do
      get home_path
      expect(response).to have_http_status(:ok)
    end

    it 'ログアウトするとトップ画面に戻る' do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
