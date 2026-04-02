namespace :cleanup do
  desc "Delete old guest users"
  task guest_users: :environment do
    threshold = 7.days.ago

    users = User.where(guest: true)
                .where("created_at < ?", threshold)

    puts "Deleting #{users.count} guest users..."
    Rails.logger.info "Deleting #{users.count} guest users..."

    deleted_count = 0

    users.find_each do |user|
      user.destroy!
      deleted_count += 1
    end

    puts "Deleted #{deleted_count} guest users"
    Rails.logger.info "Deleted #{deleted_count} guest users"
  end
end