FactoryBot.define do
  factory :want_to_eat_item do
    association :user
    association :item
  end
end
