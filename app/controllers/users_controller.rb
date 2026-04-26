class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update(user_params)
      redirect_to settings_path, notice: "通知設定を更新しました"
    else
      redirect_to settings_path, alert: "更新に失敗しました"
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # LINE連携していないユーザーに通知を作成
      if @user.line_user_id.blank?
        Notification.create!(
          user: @user,
          notification_type: "system",
          message: "LINE通知機能が追加されました！\n設定一覧からLINE通知を受け取る設定ができます。",
        )

        redirect_to home_path
      else
        render :new
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:line_notify_enabled)
  end
end