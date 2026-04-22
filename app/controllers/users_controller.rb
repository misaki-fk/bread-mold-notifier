class UsersController < ApplicationController
end
class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update(user_params)
      redirect_to settings_path, notice: "通知設定を更新しました"
    else
      redirect_to settings_path, alert: "更新に失敗しました"
    end
  end

  private

  def user_params
    params.require(:user).permit(:line_notify_enabled)
  end
end