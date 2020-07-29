FactoryBot.define do
  factory :message do
    sequence(:content) { |n| "これは#{n}個目のコメントです。" }
    association :room
    association :user
  end
end
