require 'rails_helper'

RSpec.describe 'アクセス制御', type: :request do
  let(:user) { create(:user) }


  context '未ログイン時' do
    it 'ホーム画面にアクセスするとログイン画面へリダイレクトされる' do
      get home_path
      expect(response).to redirect_to(new_user_session_path)
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
