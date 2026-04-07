class InvitationsController < ApplicationController
  before_action :authenticate_user!

  # 招待リンク作成 
  def create
    Rails.logger.info "=== INVITE CREATE CALLED ==="
    group = current_user.groups.find(params[:group_id])

    invitation = group.invitations.create!(
      token: SecureRandom.urlsafe_base64,
      expires_at: 3.days.from_now
    )

    redirect_to group_path(group, invite_token: invitation.token)
  end

  # 招待ページ表示
  def show
    @invitation = Invitation.find_by!(token: params[:token])
    @group = @invitation.group
  end

  # 参加処理
  def join
    invitation = Invitation.find_by!(token: params[:token])

    if invitation.expires_at < Time.current
      redirect_to root_path, alert: "期限切れです"
      return
    end

    unless invitation.group.users.include?(current_user)
      invitation.group.users << current_user
    end
    session[:group_id] = invitation.group.id

    redirect_to group_path(invitation.group), notice: "グループに参加しました！"
  end
end