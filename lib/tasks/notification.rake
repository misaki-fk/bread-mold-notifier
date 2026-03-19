namespace :notification do
  desc "通知チェック"
  task check: :environment do
    Bread.find_each do |bread|
      user = bread.user

      #① 期限切れ当日通知
      if bread.expiration_date == Date.today
        unless Notification.exists?(
          user: user,
          bread: bread,
          notification_type: "expiration_today",
          created_at: Time.zone.today.all_day
        )
        Notification.create!(
          user: user,
          bread: bread,
          notification_type: "expiration_today",
          message: "パンの消費期限が今日までです！",
          notified_at: Time.zone.now
        )
        end
      end

      #② 明日在庫切れ通知
      if bread.daily_consumption > 0
        tomorrow_remaining = bread.remaining_count - bread.daily_consumption

        if tomorrow_remaining <= 0 && bread.remaining_count > 0
          unless Notification.exists?(
            user: user,
            bread: bread,
            notification_type: "run_out_tomorrow",
            created_at: Time.zone.today.all_day
          )
            Notification.create!(
              user: user,
              bread: bread,
              notification_type: "run_out_tomorrow",
              message: "明日パンの在庫がなくなります！",
              notified_at: Time.zone.now
            )
          end
        end
      end
    end
  end
end

