FactoryBot.define do
  factory :manufacturer do
    sequence(:name) { |n| "これはメーカー_#{n}です。" }
  end
end
