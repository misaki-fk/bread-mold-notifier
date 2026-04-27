class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted? && user.line_user_id.blank?
        Notification.create!(
          user: user,
          notification_type: "system",
          message: "LINE通知機能が追加されました！\n設定一覧からLINE通知を受け取る設定ができます。"
        )
      end
    end
  end
end