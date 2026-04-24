namespace :notification do
  desc "通知作成"
  task create: :environment do
    Bread.where(users: { notify_enabled: true })
         .where("remaining_count > 0")
         .where("expiration_date >= ?", Date.today)
         .find_each do |bread|
      bread.notify_if_needed
    end
  end
end

namespace :notification do
  desc "通知送信"
  task send: :environment do
    Notification.where(line_sent: false).find_each do |notification|
      user = notification.user

      next unless user.line_user_id.present?
      next unless user.line_notify_enabled?

      LineClient.push_message(user, notification.message)

      notification.update!(line_sent: true)
    end
  end
end