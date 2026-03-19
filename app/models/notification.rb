class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bread

  enum notification_type: {
    # 期限切れ当日通知
    expiration_today: "expiration_today",
    # 明日在庫切れ通知
    run_out_tomorrow: "run_out_tomorrow"
  }
end
