require 'rails_helper'

RSpec.describe "Breads", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/breads/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/breads/create"
      expect(response).to have_http_status(:success)
    end
  end

end
