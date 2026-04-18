FactoryBot.define do
  factory :group do
    name { "テストグループ" }

    trait :with_user do
      after(:create) do |group|
        group.users << create(:user)
      end
    end
  end
end