class Notification < ApplicationRecord
  after_create :send_line_notification

  belongs_to :user
  belongs_to :bread

  enum notification_type: {
    # 期限切れ当日通知
    expiration_today: "expiration_today",
    # 明日在庫切れ通知
    run_out_tomorrow: "run_out_tomorrow"
  }

    private

  def send_line_notification
    return unless user.line_user_id.present?
    return unless user.line_notify_enabled?

    LineClient.push_message(user, message)
  end
end
