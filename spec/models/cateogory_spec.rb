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
  describe "check count of name characters" do
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

  # 画像のアップロード
  describe "check image upload" do
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
      image_path = Rails.root.join("public/default/default_user.png")
      category = FactoryBot.build(:category, image: File.open(image_path))
      category.save
      expect(category.image.url).to eq "/uploads/category/image/#{category.id}/default_user.png"
    end
  end

  # カテゴリー削除時に、紐づく商品も全て削除されること
  it "destroys all items when category is deleted" do
    category = FactoryBot.build(:category)
    category.save
    10.times { FactoryBot.create(:item, category: category) }
    expect { category.destroy }.to change(Item.all, :count).by(-10)
  end

  # 検索機能
  describe "search method" do
    before do
      FactoryBot.create(:category, name: "rubyonrails")     # OKパターン
      FactoryBot.create(:category, name: "car_onroad")      # OKパターン
      FactoryBot.create(:category, name: "train_on_road")   # NGパターン
    end

    # 検索文字列に部分一致するカテゴリを検索できること
    it "can search categories if keyword matches partially" do
      categories = Category.search("onr")
      expect(categories.count).to eq 2
    end

    # 条件に一致するものがない場合、blankとなること
    it "can search categories if keyword matches partially" do
      categories = Category.search("abc")
      expect(categories.blank?).to be_truthy
    end
  end

  # 有効なデータで更新ができること
  it "can update with valid data" do
    FactoryBot.create(:category)
    category = Category.first
    image_path = Rails.root.join("public/default/default_user.png")
    expect { category.update(name: "update_test", image: File.open(image_path)) }.to change(Category.all, :count).by(0)
    expect(category.name).to eq "update_test"
    expect(category.image.url).to eq "/uploads/category/image/#{category.id}/default_user.png"
  end
end
