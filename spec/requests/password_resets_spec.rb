require 'rails_helper'

RSpec.describe 'パスワードリセット', type: :request do
  let(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'oldpassword',
      password_confirmation: 'oldpassword'
    )
  end

  before do
    ActionMailer::Base.deliveries.clear
  end

  it 'パスワードリセットメールを送信し、新しいパスワードでログインできる' do
    # =========================
    # ① パスワードリセットメール送信
    # =========================
    post user_password_path, params: {
      user: { email: user.email }
    }

    expect(response).to redirect_to(new_user_session_path)
    expect(ActionMailer::Base.deliveries.count).to eq 1

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include(user.email)
    expect(mail.subject).to be_present

    # =========================
    # ② トークンを使ってパスワード更新
    # =========================
    raw_token, encrypted_token =
      Devise.token_generator.generate(User, :reset_password_token)
    
    user.update!(
      reset_password_token: encrypted_token,
      reset_password_sent_at: Time.current
    )
    
    put user_password_path, params: {
      user: {
        reset_password_token: raw_token,
        password: 'newpassword123',
        password_confirmation: 'newpassword123'
      }
    }

    expect(response).to redirect_to(home_path)

    # =========================
    # ③ 新しいパスワードでログインできる
    # =========================
    post user_session_path, params: {
      user: {
        email: user.email,
        password: 'newpassword123'
      }
    }

    expect(response).to redirect_to(home_path)
  end
end
