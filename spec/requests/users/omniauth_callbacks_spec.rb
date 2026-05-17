require 'rails_helper'

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  describe 'GET /users/auth/line/callback' do
    before do
      # OmniAuth をテストモードに
      OmniAuth.config.test_mode = true
      # Devise が認識できるようにマッピング設定
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    end

    after do
      OmniAuth.config.mock_auth[:line] = nil
      Rails.application.env_config["omniauth.auth"] = nil
    end

    context 'LINE認証が成功し、新規ユーザーのとき' do
      before do
        mock_auth = OmniAuth::AuthHash.new(
          provider: 'line',
          uid: 'line_user_12345',
          info: { name: 'テストユーザー', email: 'test@example.com' }
        )
        OmniAuth.config.mock_auth[:line] = mock_auth
        Rails.application.env_config["omniauth.auth"] = mock_auth
      end

      it '新規ユーザーが作成される' do
        expect {
          get user_line_omniauth_callback_path
        }.to change(User, :count).by(1)
      end
    end

    context 'LINE認証が成功し、既存ユーザーのとき' do
      let!(:existing_user) do
        create(:user, line_user_id: 'line_user_12345')
      end

      before do
        mock_auth = OmniAuth::AuthHash.new(
          provider: 'line',
          uid: 'line_user_12345',
          info: { name: 'テスト', email: 'test@example.com' }
        )
        OmniAuth.config.mock_auth[:line] = mock_auth
        Rails.application.env_config["omniauth.auth"] = mock_auth
      end

      it '新規ユーザーは作られない（既存ユーザーでログインする）' do
        expect {
          get user_line_omniauth_callback_path
        }.not_to change(User, :count)
      end
    end
  end
end