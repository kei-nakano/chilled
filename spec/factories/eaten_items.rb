FactoryBot.define do
  factory :eaten_item do
    association :user
    association :item
  end
end
