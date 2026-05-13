FactoryBot.define do
  factory :default_bread do
    user
    bread_type
    total_count { 1 }
    daily_consumption { 1 }
  end
end
