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
    Rails.logger.info "LINE送信開始"
    Rails.logger.info "user_id: #{user.line_user_id}"
    Rails.logger.info "token: #{ENV["LINE_CHANNEL_TOKEN"].present?}"
    return unless user.line_user_id.present?
    return unless user.line_notify_enabled?

    LineClient.push_message(user, message)
  end
end
