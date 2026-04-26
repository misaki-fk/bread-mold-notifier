namespace :notification do
  desc "通知作成"
  task create: :environment do
    Bread.joins(:user)
         .where(users: { line_notify_enabled: true })
         .where("remaining_count > 0")
         .where("expiration_date >= ?", Time.zone.today)
         .find_each do |bread|
      bread.notify_if_needed
    end
  end

  desc "通知送信"
  task send: :environment do
    Notification.where(line_sent: false)
                .where("created_at >= ?", Time.zone.today)
                .find_each do |notification|

      user = notification.user

      next unless user.line_user_id.present?
      next unless user.line_notify_enabled?

      begin
        LineClient.push_message(user, notification.line_message)
        notification.update!(line_sent: true)
      rescue => e
        Rails.logger.error "[LINE送信失敗] #{e.message}"
      end
    end
  end
end