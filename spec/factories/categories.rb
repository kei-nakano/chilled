FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "これはカテゴリー_#{n}です。" }
  end
end
