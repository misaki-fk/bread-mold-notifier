require 'rails_helper'

RSpec.describe 'パスワードリセット', type: :request do
  let!(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  before do
    ActionMailer::Base.deliveries.clear
  end

  it 'パスワードリセットメールを送信できる' do
    post user_password_path, params: {
      user: { email: user.email }
    }

    expect(response).to have_http_status(:found) # 302
    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end
end
