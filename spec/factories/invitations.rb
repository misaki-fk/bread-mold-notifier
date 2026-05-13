FactoryBot.define do
  factory :invitation do
    group
    token { SecureRandom.urlsafe_base64 }
    expires_at { 3.days.from_now }

    trait :expired do
      expires_at { 1.day.ago }
    end
  end
end
