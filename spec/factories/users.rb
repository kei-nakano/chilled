FactoryBot.define do
  factory :user do
    name { "Aaron" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "dottle-nouveau-pavilion-tights-furze" }
    # ファクトリーの継承
    # factory :project_due_yesterday do
    # due_on 1.day.ago
    # end
  end

  factory :admin, class: User do
    name { "Admin" }
    sequence(:email) { |n| "administator#{n}@example.com" }
    password { "password" }
    admin { true }
  end
end
