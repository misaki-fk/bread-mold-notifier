require 'rails_helper'

RSpec.describe Bread, type: :model do
  describe '関連' do
    context 'bread_type が nil のとき' do
      it '無効である' do
        bread = build(:bread)
        bread.bread_type = nil
        expect(bread).to be_invalid
      end
    end

    context 'group が nil のとき' do
      it '無効である' do
        bread = build(:bread)
        bread.group = nil
        expect(bread).to be_invalid
      end
    end

    context '関連が全部揃っているとき' do
      it '有効である' do
        bread = build(:bread)
        expect(bread).to be_valid
      end
    end
  end
end