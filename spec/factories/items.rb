FactoryBot.define do
  factory :item, class: Item do
    sequence(:title) { |n| "商品：#{n}" }
    content { "もちっとした食感の平 打ち生パスタ (タリアテッレ) を使用。じっくりと煮込んだ牛肉と北海道産生ク" }
    price { 250 }
    gram { 295 }
    calorie { 472 }
    manufacturer
    category
  end
end
