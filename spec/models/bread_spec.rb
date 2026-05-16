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

  describe 'バリデーション' do
    context 'expiration_date が nil のとき' do
      it '無効である' do
        bread = build(:bread, expiration_date: nil)
        expect(bread).to be_invalid
      end
    end

    context 'total_count が nil のとき' do
      it '無効である' do
        bread = build(:bread, total_count: nil)
        expect(bread).to be_invalid
      end
    end

    context 'daily_consumption が nil のとき' do
      it '無効である' do
        bread = build(:bread, daily_consumption: nil)
        expect(bread).to be_invalid
      end
    end

    context 'daily_consumption が 0 のとき' do
      it '無効である' do
        bread = build(:bread, daily_consumption: 0)
        expect(bread).to be_invalid
      end
    end

    context 'daily_consumption が小数のとき' do
      it '無効である' do
        bread = build(:bread, daily_consumption: 1.5)
        expect(bread).to be_invalid
      end
    end
  end

  describe '#days_until_expiration' do
    context 'expiration_date が nil のとき' do
      it 'nil を返す' do
        bread = build(:bread, expiration_date: nil)
        expect(bread.days_until_expiration).to be_nil
      end
    end

    context 'expiration_date が今日のとき' do
      it '0 を返す' do
        bread = build(:bread, expiration_date: Time.zone.today)
        expect(bread.days_until_expiration).to eq(0)
      end
    end

    context 'expiration_date が3日後のとき' do
      it '3 を返す' do
        bread = build(:bread, expiration_date: Time.zone.today + 3)
        expect(bread.days_until_expiration).to eq(3)
      end
    end

    context 'expiration_date が昨日のとき' do
      it '-1 を返す' do
        bread = build(:bread, expiration_date: Time.zone.today - 1)
        expect(bread.days_until_expiration).to eq(-1)
      end
    end
  end
end
