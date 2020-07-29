FactoryBot.define do
  factory :user, aliases: [:follower] do
    name { "Aaron" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "dottle-nouveau-pavilion-tights-furze" }
    # ファクトリーの継承
    # factory :project_due_yesterday do
    # due_on 1.day.ago
    # end
  end

  factory :admin, aliases: [:followed], class: User do
    name { "Admin" }
    sequence(:email) { |n| "administator#{n}@example.com" }
    password { "password" }
    admin { true }
    activated { true }
  end
end
