require 'rails_helper'

RSpec.describe "Groups", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user
  end

  describe 'POST /groups' do
    it 'グループを作成できる' do
      expect {
        post groups_path, params: {
          group: { name: 'テスト'}
        }
      }.to change(Group, :count).by(1)
    end

    it '作成者がメンバーに追加される' do
      post groups_path, params: {
        group: { name: 'テスト' }
      }

      group = Group.last
      expect(group.users).to include(user)
    end

    it 'sessionにgroup_idが保存される' do
      post groups_path, params: {
        group: { name: 'テスト' }
      }

      expect(session[:group_id]).to eq(Group.last.id)
    end
  end

  describe 'GET /groups/:id' do
    it '自分のグループは見れる' do
      group = create(:group)
      group.users << user

      get group_path(group)

      expect(response).to have_http_status(:ok)
    end

    it '他人のグループは見れない' do
      group = create(:group)
      group.users << other_user
    
      get group_path(group)
    
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /groups/:id/switch' do
    it 'グループを切り替えられる' do
      group = create(:group)
      user.groups << group
      user.reload

      patch  switch_group_path(group)

      expect(response).to redirect_to(home_path)
    end
  end

  describe 'DELETE /groups/:id' do
    it '通常のグループは削除できる' do
      group = create(:group)
      group.users << user

      expect {
        delete group_path(group)
      }.to change(Group, :count).by(-1)
    end

    it 'defaultグループは削除できない' do
      group = create(:group)
      group.users << user

      allow_any_instance_of(Group).to receive(:default?).and_return(true)

      delete group_path(group)

      expect(response).to redirect_to(group_path(group))
    end

    it '削除したグループがsessionにあればクリアされる' do
      group = create(:group)
      group.users << user

      # sessionセット
      post switch_group_path(group)

      delete group_path(group)

      expect(session[:group_id]).to be_nil
    end
  end

  
end