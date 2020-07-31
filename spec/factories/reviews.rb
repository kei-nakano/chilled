FactoryBot.define do
  factory :review do
    score { 2.5 }
    sequence(:content) { |n| "#{n}：パッケージだと美味しそうな画像だったんですけど、実際に調理してみると全然ショボかったです。" }
    association :user
    association :item

    trait :with_tags do
      tag_list { "美味しい, 不味い, 微妙" }
    end
  end
end
