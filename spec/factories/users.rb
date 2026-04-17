FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_group do
      after(:create) do |user|
        group = create(:group)
        group.users << user
      end
    end
  end
end