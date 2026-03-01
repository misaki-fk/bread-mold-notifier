require 'rails_helper'

RSpec.describe "Guests", type: :request do
  describe "GET /signup_prompt" do
    it "returns http success" do
      get "/guest/signup_prompt"
      expect(response).to have_http_status(:success)
    end
  end

end
