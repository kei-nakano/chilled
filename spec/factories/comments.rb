FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "これは#{n}個目のコメントです。" }
    association :review
    association :user
  end
end
