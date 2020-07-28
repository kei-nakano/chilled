require 'rails_helper'

RSpec.describe Category, type: :model do
  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:category)).to be_valid
  end

  # 名前の存在
  describe "presence of name" do
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
  end

  # 名前の文字数(15文字以内)
  describe "check characters count of name" do
    # 16文字の名前は無効であること
    it "is invalid with a name which has over 15 characters" do
      category = FactoryBot.build(:category, name: "あ" * 16)
      category.valid?
      expect(category.errors[:name]).to include("は15文字以内で入力してください")
    end

    # 15文字の名前は有効であること
    it "is valid with a name which has 15 characters" do
      category = FactoryBot.build(:category, name: "あ" * 15)
      category.valid?
      expect(FactoryBot.build(:category)).to be_valid
    end
  end

  # 重複した名前なら無効な状態であること
  it "is invalid with a duplicate name" do
    FactoryBot.create(:category, name: "test")
    category = FactoryBot.build(:category, name: "test")
    category.valid?
    expect(category.errors[:name]).to include("はすでに存在します")
  end

  # 画像なしでも有効であること
  it "is valid with no image" do
    category = FactoryBot.build(:category, image: nil)
    category.valid?
    expect(category).to be_valid
  end

  # 画像なしの場合、デフォルト画像が設定されること
  it "has a default image with no image" do
    category = FactoryBot.build(:category, image: nil)
    expect(category.image.url).to eq "/default/no_image.png"
  end

  # デフォルト画像以外の画像を設定できること
  it "can set an image except default image" do
    category = FactoryBot.build(:category, image: File.open(Rails.root.join("public/default/default_user.png")))
    category.save
    expect(category.image.url).to eq "/uploads/category/image/#{category.id}/default_user.png"
  end
end
