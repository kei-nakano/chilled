FactoryBot.define do
  factory :user, aliases: %i[follower from] do
    sequence(:name) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "Password12" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :other, aliases: %i[followed blocked], class: User do
    sequence(:name) { |n| "other_#{n}" }
    sequence(:email) { |n| "other_#{n}@example.com" }
    password { "Password12" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :admin, class: User do
    name { "admin" }
    email { "admin@example.com" }
    password { "Password12" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end
end
