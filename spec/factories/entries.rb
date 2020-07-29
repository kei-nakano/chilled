FactoryBot.define do
  factory :entry do
    association :user
    association :room
  end
end
