namespace :notification do
  desc "通知チェック"
  task check: :environment do
    Bread.find_each do |bread|
      bread.send(:notify_if_needed)
    end
  end
end