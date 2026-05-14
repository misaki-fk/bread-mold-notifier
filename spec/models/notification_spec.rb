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

  describe '#display_message' do
    context 'expiration_today のとき' do
      it '期限切れメッセージを返す' do
        notification = build(:notification, notification_type: 'expiration_today')
        expect(notification.display_message).to eq('パンの消費期限が今日までです')
      end
    end

    context 'run_out_tomorrow のとき' do
      it '在庫切れメッセージを返す' do
        notification = build(:notification, notification_type: 'run_out_tomorrow')
        expect(notification.display_message).to eq('パンの在庫が明日なくなります')
      end
    end

    context 'system のとき' do
      it 'message属性をそのまま返す' do
        notification = build(
          :notification,
          notification_type: 'system',
          bread: nil,
          message: 'システムからのお知らせです'
        )
        expect(notification.display_message).to eq('システムからのお知らせです')
      end
    end
  end

  describe '#line_message' do
    context 'expiration_today のとき' do
      it '挨拶と display_message が含まれる' do
        notification = build(:notification, notification_type: 'expiration_today')
        expect(notification.line_message).to include('おはようございます')
        expect(notification.line_message).to include(notification.display_message)
      end
    end

    context 'run_out_tomorrow のとき' do
      it '挨拶と display_message が含まれる' do
        notification = build(:notification, notification_type: 'run_out_tomorrow')
        expect(notification.line_message).to include('おはようございます')
        expect(notification.line_message).to include(notification.display_message)
      end
    end

    context 'system のとき' do
      it 'nil を返す' do
        notification = build(
          :notification,
          notification_type: 'system',
          bread: nil,
          message: 'システム通知'
        )
        expect(notification.line_message).to be_nil
      end
    end
  end
end
