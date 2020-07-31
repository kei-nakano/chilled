FactoryBot.define do
  factory :user, aliases: %i[follower from] do
    name { "Aaron" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "Password12" }
  end

  factory :admin, aliases: %i[followed blocked], class: User do
    name { "Admin" }
    sequence(:email) { |n| "administator#{n}@example.com" }
    password { "Password12" }
    admin { true }
    activated { true }
  end
end
