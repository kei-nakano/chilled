FactoryBot.define do
  factory :user, aliases: %i[follower from] do
    sequence(:name) { |n| "user_#{n}" }
    sequence(:email) { |n| "no_#{n}@example.com" }
    password { "Password12" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :admin, aliases: %i[followed blocked], class: User do
    sequence(:name) { |n| "admin_#{n}" }
    sequence(:email) { |n| "admin_#{n}@example.com" }
    password { "Password12" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end
end
