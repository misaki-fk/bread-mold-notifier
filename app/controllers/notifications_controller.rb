class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 先に既読にする
    current_user.notifications.where(is_read: false).update_all(is_read: true)
    
    # その後に取得
    @notifications = current_user.notifications.includes(:bread).order(created_at: :desc)
  end
end