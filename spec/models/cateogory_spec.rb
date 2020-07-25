require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
  end

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:category)).to be_valid
  end

  # 名前があれば有効な状態であること
  it "is valid with a name" do
    category = FactoryBot.build(:category, name: "test")
    expect(category).to be_valid
  end

  # 名前がなければ無効な状態であること
  it "is invalid without a name" do
    category = FactoryBot.build(:category, name: nil)
    category.valid?
    expect(category.errors[:name]).to include("を入力してください")
  end

  # 重複した名前なら無効な状態であること
  it "is invalid with a duplicate name" do
    FactoryBot.create(:category, name: "test")
    category = FactoryBot.build(:category, name: "test")
    category.valid?
    expect(category.errors[:name]).to include("はすでに存在します")
  end
end
