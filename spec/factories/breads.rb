FactoryBot.define do
  factory :bread do
    user { create(:user) }
    bread_type
    group { user.groups.first }
    total_count { 6 }
    daily_consumption { 1 }
    expiration_date { Time.zone.today + 4.days }
  end
end