FactoryBot.define do
  factory :comment_like do
    association :user
    association :comment
  end
end
