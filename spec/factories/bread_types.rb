FactoryBot.define do
  factory :bread_type do
    sequence(:name) { |n| "パン種類#{n}" }
  end
end
