FactoryBot.define do
  factory :review, class: Review do
    score { 2.5 }
    sequence(:content) { |n| "#{n}：パッケージだと美味しそうな画像だったんですけど、実際に調理してみると全然ショボかったです。" }
    sequence(:tag_list) { |n| "#{n}, 美味しい, まずい" }
    user
    item
  end
end
