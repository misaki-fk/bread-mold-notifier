require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe '関連' do
    context 'userがnilの時' do
      it '無効であること' do
        notification = build(:notification, user: nil)
        expect(notification).to be_invalid
      end
    end

    context 'userがある時' do
      it '有効であること' do
        notification = build(:notification)
        expect(notification).to be_valid
      end
    end

    context 'user / bread 両方ある時' do
      it '有効であること' do
        notification = build(:notification)
        expect(notification).to be_valid
      end
    end
  end

  describe 'enum notification_type' do
    it '3つの値が定義されていること' do
      expect(Notification.notification_types.keys).to contain_exactly(
        'expiration_today', 'run_out_tomorrow', 'system')
    end

    it '無効な値を設定するとエラーになる' do
      expect {
        build(:notification, notification_type: 'invalid')
      }.to raise_error(ArgumentError)
    end
  end
end
