FactoryBot.define do
  factory :review_like do
    association :user
    association :review
  end
end
