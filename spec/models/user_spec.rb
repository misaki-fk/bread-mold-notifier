require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'email が空のとき' do
      it '無効である' do
        user = build(:user, email: '')
        expect(user).to be_invalid
      end
    end

    context 'password が空のとき' do
      it '無効である' do
        user = build(:user, password: '')
        expect(user).to be_invalid
      end
    end

    context 'password が短すぎるとき' do
      it '無効である' do
        user = build(:user, password: 'abc')
        expect(user).to be_invalid
        # password:（6文字未満）は無効
      end
    end

    context '必要な属性が揃っているとき' do
      it '有効である' do
        user = build(:user)
        expect(user).to be_valid
      end
    end
  end

  describe '.create_guest' do
    let(:user) { User.create_guest }

    it 'ゲストユーザーを作成してDBに保存する' do
      expect(user).to be_persisted
    end

    it 'guest 属性が true である' do
      expect(user.guest).to be true
    end

    it 'email が guest_ で始まる' do
      expect(user.email).to start_with('guest_')
    end
  end
end