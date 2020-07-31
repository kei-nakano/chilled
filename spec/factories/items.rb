FactoryBot.define do
  factory :item do
    sequence(:title) { |n| "商品：#{n}" }
    content { "もちっとした食感の平 打ち生パスタ (タリアテッレ) を使用。" }
    price { 250 }
    gram { 295 }
    calorie { 472 }
    association :manufacturer
    association :category
  end
end
