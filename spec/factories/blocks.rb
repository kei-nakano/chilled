FactoryBot.define do
  factory :block do
    association :from
    association :blocked
  end
end
