namespace :notification do
  desc "通知チェック"
  task check: :environment do
    Rails.logger.info "Cron START"

    Bread.find_each do |bread|
      bread.send(:notify_if_needed)
    end

    Notification.where(line_sent: false).find_each do |notification|
      user = notification.user

      next unless user.line_user_id.present?
      next unless user.line_notify_enabled?

      LineClient.push_message(user, notification.message)

      notification.update!(line_sent: true)
    end
  end
end