require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe '関連' do
    context 'userがnilの時' do
      it '無効であること' do
        membership = build(:membership, user: nil)
        expect(membership).to be_invalid
      end
    end

    context 'groupがnilの時' do
      it '無効であること' do
        membership = build(:membership, group: nil)
        expect(membership).to be_invalid
      end
    end

    context 'userとgroupが両方ある時' do
      it '有効であること' do
        membership = build(:membership)
        expect(membership).to be_valid
      end
    end
  end
end
