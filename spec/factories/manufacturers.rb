FactoryBot.define do
  factory :manufacturer do
    sequence(:name) { |n| "メーカー：#{n}" }
  end
end
