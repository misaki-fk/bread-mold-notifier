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

  describe '#remaining_count' do
    context '作成当日のとき' do
      it 'total_count をそのまま返す' do
        bread = build(:bread, total_count: 6, daily_consumption: 1)
        bread.created_at = Time.current
        expect(bread.remaining_count).to eq(6)
      end
    end

    context '作成から3日経過したとき' do
      it 'total_count から3日分の消費を引いた値を返す' do
        bread = build(:bread, total_count: 10, daily_consumption: 2)
        bread.created_at = 3.days.ago
        expect(bread.remaining_count).to eq(4)   # 10 - (2 × 3) + 0 = 4
      end
    end

    context 'adjustment_count があるとき' do
      it '計算結果に adjustment_count が加算される' do
        bread = build(
          :bread,
          total_count: 6,
          daily_consumption: 1,
          adjustment_count: 2
        )
        bread.created_at = 2.days.ago
        expect(bread.remaining_count).to eq(6)   # 6 - 2 + 2 = 6
      end
    end
  end

    describe '#increase_adjustment!' do
    it 'adjustment_count を +1 する' do
      bread = create(:bread, adjustment_count: 0)
      bread.increase_adjustment!
      expect(bread.adjustment_count).to eq(1)
    end
  end

  describe '#decrease_adjustment!' do
    it 'adjustment_count を -1 する' do
      bread = create(:bread, adjustment_count: 0)
      bread.decrease_adjustment!
      expect(bread.adjustment_count).to eq(-1)
    end
  end

  describe '#status_message' do
    context 'remaining_count が 0 のとき' do
      it '完食メッセージを返す' do
        bread = build(:bread, total_count: 0, daily_consumption: 1)
        bread.created_at = Time.current
        expect(bread.status_message).to eq("完食しました🎉")
      end
    end

    context '期限切れのとき' do
      it '危険メッセージを返す' do
        bread = build(:bread, total_count: 10, daily_consumption: 1, expiration_date: 1.day.ago)
        bread.created_at = Time.current
        expect(bread.status_message).to eq("危険です（自己責任）❗️")
      end
    end

    context '期限が今日のとき' do
      it '今日までメッセージを返す' do
        bread = build(:bread, expiration_date: Time.zone.today)
        bread.created_at = Time.current
        expect(bread.status_message).to eq("期限が今日までです⚠️")
      end
    end

    context '期限が明日のとき' do
      it '明日が消費期限メッセージを返す' do
        bread = build(:bread, expiration_date: Time.zone.today + 1)
        bread.created_at = Time.current
        expect(bread.status_message).to eq("明日が消費期限です")
      end
    end

    context '期限まで余裕があるとき' do
      it 'まだ大丈夫メッセージを返す' do
        bread = build(:bread, expiration_date: Time.zone.today + 5)
        bread.created_at = Time.current
        expect(bread.status_message).to eq("まだ大丈夫です👍")
      end
    end
  end
end
