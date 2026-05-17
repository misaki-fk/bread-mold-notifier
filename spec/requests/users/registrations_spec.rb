require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe 'POST /users（新規登録）' do
    context '有効なパラメータのとき' do
      let(:valid_params) do
        {
          user: {
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'Userが作成される' do
        expect {
          post user_registration_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'システム通知（LINE案内）が作成される' do
        expect {
          post user_registration_path, params: valid_params
        }.to change(Notification, :count).by(1)
      end

      it 'ホーム画面にリダイレクトされる' do
        post user_registration_path, params: valid_params
        expect(response).to redirect_to(home_path)
      end
    end

    context '無効なパラメータのとき' do
      let(:invalid_params) do
        {
          user: {
            email: '',                            # ← email を空に
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'Userは作成されない' do
        expect {
          post user_registration_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
  end
end