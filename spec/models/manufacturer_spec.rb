require 'rails_helper'

RSpec.describe Manufacturer, type: :model do
  before do
  end

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:manufacturer)).to be_valid
  end

  # 名前があれば有効な状態であること
  it "is valid with a name" do
    manufacturer = FactoryBot.build(:manufacturer, name: "test")
    expect(manufacturer).to be_valid
  end

  # 名前がなければ無効な状態であること
  it "is invalid without a name" do
    manufacturer = FactoryBot.build(:manufacturer, name: nil)
    manufacturer.valid?
    expect(manufacturer.errors[:name]).to include("を入力してください")
  end

  # 重複した名前なら無効な状態であること
  it "is invalid with a duplicate name" do
    FactoryBot.create(:manufacturer, name: "test")
    manufacturer = FactoryBot.build(:manufacturer, name: "test")
    manufacturer.valid?
    expect(manufacturer.errors[:name]).to include("はすでに存在します")
  end
end
