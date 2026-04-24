namespace :notification do
  desc "通知チェック"
  task check: :environment do
    Rails.logger.info "Cron START"
    Rails.logger.info "today: #{Time.zone.today}"
    Bread.find_each do |bread|
      Rails.logger.info "bread_id: #{bread.id}"
      Rails.logger.info "expiration: #{bread.expiration_date}"
      Rails.logger.info "remaining: #{bread.remaining_count}"
      
      bread.send(:notify_if_needed)
    end
  end
end