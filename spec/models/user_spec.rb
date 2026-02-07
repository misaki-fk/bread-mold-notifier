require 'rails_helper'

RSpec.describe User, type: :model do
    it '正常にユーザーを作成できる' do
    user = User.new(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    )

    expect(user).to be_valid
  end
end

