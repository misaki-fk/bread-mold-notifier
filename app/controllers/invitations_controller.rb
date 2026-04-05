class InvitationsController < ApplicationController
  def show
    invitation = Invitation.find_by!(token: params[:token])

    invitation.group.users << current_user

    redirect_to invitation.group, notice: "グループに参加しました"
  end
end