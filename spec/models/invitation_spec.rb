require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe '関連' do
    context 'group がnilの時' do
      it '無効であること' do
        invitation = build(:invitation, group: nil)
        expect(invitation).to be_invalid
      end
    end

    context 'groupがある時' do
      it '有効であること' do
        invitation = build(:invitation)
        expect(invitation).to be_valid
      end
    end
  end
end