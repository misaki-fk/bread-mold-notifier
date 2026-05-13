require 'rails_helper'

RSpec.describe BreadType, type: :model do
  describe 'バリデーショnン' do
    context 'nameが空の時' do
      it '無効であること' do
        bread_type = BreadType.new(name: nil)
        expect(bread_type).to be_invalid
      end
    end
    context 'nameが入っている時' do
      it '有効であること' do
        bread_type = BreadType.new(name: '食パン')
        expect(bread_type).to be_valid
      end
    end
  end
end
