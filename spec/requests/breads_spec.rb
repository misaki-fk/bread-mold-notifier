require 'rails_helper'

RSpec.describe "パン登録", type: :request do
  let(:user) { create(:user) }
  let!(:bread_type) { create(:bread_type) }

  before do
    sign_in user
  end

  it "入力した情報がカードに正しく表示される" do
    post breads_path, params: {
      bread: {
        bread_type_id: bread_type.id,
        total_count: 6,
        daily_consumption: 2,
        expiration_date: Time.zone.today + 3
      }
    }

    follow_redirect!

    expect(response.body).to include("6")
  end
end

RSpec.describe "パン登録の認可", type: :request do
  describe '未ログイン時' do
    it 'GET /breads/new はログイン画面にリダイレクトされる' do
      get new_bread_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'POST /breads はログイン画面にリダイレクトされる' do
      post breads_path, params: {
        bread: {
          bread_type_id: 1,
          total_count: 6,
          daily_consumption: 1,
          expiration_date: Time.zone.today + 3
        }
      }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'GET /breads/:id/edit はログイン画面にリダイレクトされる' do
      bread = create(:bread)
      get edit_bread_path(bread)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'ログイン中、他人のbreadへのアクセス' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:other_bread) { create(:bread, user: other_user) }

    before { sign_in user }

    it 'GET /breads/:id/edit は 404 を返す' do
      get edit_bread_path(other_bread)
      expect(response).to have_http_status(:not_found)
    end

    it 'PATCH /breads/:id は 404 を返す' do
      patch bread_path(other_bread), params: { bread: { total_count: 10 } }
      expect(response).to have_http_status(:not_found)
    end

    it 'DELETE /breads/:id は 404 を返す' do
      delete bread_path(other_bread)
      expect(response).to have_http_status(:not_found)
    end
  end
end