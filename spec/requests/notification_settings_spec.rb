require 'rails_helper'

RSpec.describe "NotificationSettings", type: :request do
  describe 'GET /notification_setting' do
    context '未ログインのとき' do
      it 'ログイン画面にリダイレクトされる' do
        get notification_setting_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログイン中（通常ユーザー）のとき' do
      let(:user) { create(:user) }
      before { sign_in user }

      it 'ページを表示できる' do
        get notification_setting_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログイン中（ゲストユーザー）のとき' do
      let(:guest) { User.create_guest }
      before { sign_in guest }

      it '会員登録誘導画面にリダイレクトされる' do
        get notification_setting_path
        expect(response).to redirect_to(guest_signup_prompt_path)
      end
    end
  end
end