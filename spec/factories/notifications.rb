FactoryBot.define do
  factory :notification do
    user { nil }
    bread { nil }
    notification_type { "MyString" }
    message { "MyString" }
    is_read { false }
    notified_at { "2026-03-19 13:51:06" }
  end
end
