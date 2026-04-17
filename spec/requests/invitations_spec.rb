require 'rails_helper'

RSpec.describe "Invitations", type: :request do
  let(:user) { create(:user) }
  let(:group) { create(:group, :with_user) }

  before do
    sign_in user
  end

  describe 'POST /groups/:id/invitations' do
    it '招待リンクを作成できる' do
      group = create(:group)
      group.users << user

      expect {
        post group_invitations_path(group)
      }.to change(Invitation, :count).by(1)
    end

    it 'トークン付きでリダイレクトされる' do
      group = create(:group)
      group.users << user

      post group_invitations_path(group)

      invitation = Invitation.last
      expect(response).to redirect_to(group_path(group, invite_token: invitation.token))
    end
  end

  describe 'GET /invitations/:token' do
    it '招待ページを表示できる' do
      group = create(:group)
      invitation = Invitation.create!(
        group: group,
        token: SecureRandom.urlsafe_base64,
        expires_at: 3.days.from_now
      )

      get invitation_path(invitation.token)

      expect(response).to have_http_status(:ok)
    end

    it '無効なトークンの場合エラーになる' do
      expect {
        get invitation_path("invalidtoken")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST /invitations/:token/join' do
    it 'グループに参加できる' do
      group = create(:group)
      invitation = Invitation.create!(
        group: group,
        token: SecureRandom.urlsafe_base64,
        expires_at: 3.days.from_now
      )

      post join_invite_path(invitation.token)

      expect(group.users).to include(user)
      expect(session[:group_id]).to eq(group.id)
      expect(response).to redirect_to(home_path)
    end

    it '期限切れのトークンは参加できない' do
      group = create(:group)
      invitation = Invitation.create!(
        group: group,
        token: SecureRandom.urlsafe_base64,
        expires_at: 1.hour.ago
      )

      post join_invite_path(invitation.token)

      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response.body).to include("期限切れです")
    end

    it '既に参加している場合は重複しない' do
      group = create(:group)
      group.users << user
      invitation = Invitation.create!(
        group: group,
        token: SecureRandom.urlsafe_base64,
        expires_at: 3.days.from_now
      )

      post join_invite_path(invitation.token)

      expect(response).to redirect_to(home_path)
    end
  end
end