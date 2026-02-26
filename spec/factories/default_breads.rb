FactoryBot.define do
  factory :default_bread do
    user { nil }
    bread_type { nil }
    total_count { 1 }
    daily_consumption { 1.5 }
  end
end
