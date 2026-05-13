FactoryBot.define do
  factory :notification do
    user
    bread
    notification_type { "expiration_today" }
    notified_at { Time.current }

    trait :run_out_tomorrow do
      notification_type { "run_out_tomorrow" }
    end

    trait :system do
      bread { nil }
      notification_type { "system" }
      message { "システムからのお知らせです" }
    end
  end
end