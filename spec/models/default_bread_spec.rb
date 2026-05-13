require 'rails_helper'

RSpec.describe DefaultBread, type: :model do
  describe '関連' do
    context 'userがnilの時' do
      it '無効であること' do
        default_bread = build(:default_bread, user: nil)
        expect(default_bread).to be_invalid
      end
    end

    context 'bread_typeがnilの時' do
      it '無効であること' do
        default_bread = build(:default_bread, bread_type: nil)
        expect(default_bread).to be_invalid
      end
    end

    context 'userとbread_typeが両方ある時' do
      it '有効であること' do
        default_bread = build(:default_bread)
        expect(default_bread).to be_valid
      end
    end
  end
end
