require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "正常にユーザーを作成できる" do
    expect(user).to be_valid
  end
end


