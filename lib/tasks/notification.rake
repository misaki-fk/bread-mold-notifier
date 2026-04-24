namespace :notification do
  desc "通知チェック"
  task check: :environment do
    Rails.logger.info "Cron START"

    Bread.find_each do |bread|
      user = bread.user
      Rails.logger.info "bread_id: #{bread.id}"

      Rails.logger.info "line_user_id: #{user.line_user_id}"
      Rails.logger.info "notify_enabled: #{user.line_notify_enabled}"
      Rails.logger.info "expiration: #{bread.expiration_date}"
      Rails.logger.info "remaining: #{bread.remaining_count}"
      
      bread.send(:notify_if_needed)
    end
  end
end