FactoryBot.define do
  factory :category, class: Category do
    sequence(:name) { |n| "これはカテゴリー_#{n}です。" }
  end
end
