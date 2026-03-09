require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  describe "GET /index" do
    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "returns success" do
        get notifications_path
        expect(response).to have_http_status(:success)
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get notifications_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end