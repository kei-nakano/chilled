FactoryBot.define do
  factory :hidden_room do
    association :user
    association :room
  end
end
