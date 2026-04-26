class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bread

  enum notification_type: {
    # 期限切れ当日通知
    expiration_today: "expiration_today",
    # 明日在庫切れ通知
    run_out_tomorrow: "run_out_tomorrow",
    system: "system"
  }

  def display_message
    case notification_type
    when "expiration_today"
      "パンの消費期限が今日までです"
    when "run_out_tomorrow"
      "明日在庫がなくなります"
    when "system"
      message
    end
  end

  def line_message
    greeting = "おはようございます ☀️"

    case notification_type
    when "expiration_today"
      "#{greeting}\n\n📢 #{display_message}\nお早めにご確認ください 👀"
    when "run_out_tomorrow"
      "#{greeting}\n\n📦 #{display_message}\n補充をお忘れなく 🛒"
    end
  end

    private

  def send_line_notification
    Rails.logger.info "LINE送信開始"
    Rails.logger.info "user_id: #{user.line_user_id}"
    Rails.logger.info "token: #{ENV["LINE_CHANNEL_TOKEN"].present?}"
    return unless user.line_user_id.present?
    return unless user.line_notify_enabled?

    LineClient.push_message(user, line_message)
  end
end
