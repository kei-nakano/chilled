FactoryBot.define do
  factory :category, class: Category do
    sequence(:name) { |n| "カテゴリー：#{n}" }
    # association :owner
  end
end
