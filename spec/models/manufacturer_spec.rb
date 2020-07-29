require 'rails_helper'

RSpec.describe Manufacturer, type: :model do
  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:manufacturer)).to be_valid
  end

  # 名前の存在
  describe "presence of name" do
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
  end

  # 名前の文字数(15文字以内)
  describe "check count of name characters" do
    # 16文字の名前は無効であること
    it "is invalid with a name which has over 15 characters" do
      manufacturer = FactoryBot.build(:manufacturer, name: "あ" * 16)
      manufacturer.valid?
      expect(manufacturer.errors[:name]).to include("は15文字以内で入力してください")
    end

    # 15文字の名前は有効であること
    it "is valid with a name which has 15 characters" do
      manufacturer = FactoryBot.build(:manufacturer, name: "あ" * 15)
      manufacturer.valid?
      expect(FactoryBot.build(:manufacturer)).to be_valid
    end
  end

  # 重複した名前なら無効な状態であること
  it "is invalid with a duplicate name" do
    FactoryBot.create(:manufacturer, name: "test")
    manufacturer = FactoryBot.build(:manufacturer, name: "test")
    manufacturer.valid?
    expect(manufacturer.errors[:name]).to include("はすでに存在します")
  end

  describe "check image upload" do
    # 画像なしでも有効であること
    it "is valid with no image" do
      manufacturer = FactoryBot.build(:manufacturer, image: nil)
      manufacturer.valid?
      expect(manufacturer).to be_valid
    end

    # 画像なしの場合、デフォルト画像が設定されること
    it "has a default image with no image" do
      manufacturer = FactoryBot.build(:manufacturer, image: nil)
      expect(manufacturer.image.url).to eq "/default/no_image.png"
    end

    # デフォルト画像以外の画像を設定できること
    it "can set an image except default image" do
      image_path = Rails.root.join("public/default/default_user.png")
      manufacturer = FactoryBot.build(:manufacturer, image: File.open(image_path))
      manufacturer.save
      expect(manufacturer.image.url).to eq "/uploads/manufacturer/image/#{manufacturer.id}/default_user.png"
    end
  end

  # カテゴリー削除時に、紐づく商品も全て削除されること
  it "destroys all items when manufacturer is deleted" do
    manufacturer = FactoryBot.build(:manufacturer)
    manufacturer.save
    10.times { FactoryBot.create(:item, manufacturer: manufacturer) }
    expect { manufacturer.destroy }.to change(Item.all, :count).by(-10)
  end

  # 検索機能
  describe "search method" do
    before do
      FactoryBot.create(:manufacturer, name: "rubyonrails")     # OKパターン
      FactoryBot.create(:manufacturer, name: "car_onroad")      # OKパターン
      FactoryBot.create(:manufacturer, name: "train_on_road")   # NGパターン
    end

    # 検索文字列に部分一致するカテゴリを検索できること
    it "can search manufacturers if keyword matches partially" do
      manufacturers = Manufacturer.search("onr")
      expect(manufacturers.count).to eq 2
    end

    # 条件に一致するものがない場合、blankとなること
    it "can search manufacturers if keyword matches partially" do
      manufacturers = Manufacturer.search("abc")
      expect(manufacturers.blank?).to be_truthy
    end
  end

  # 有効なデータで更新ができること
  it "can update with valid data" do
    FactoryBot.create(:manufacturer)
    manufacturer = Manufacturer.first
    image_path = Rails.root.join("public/default/default_user.png")
    expect { manufacturer.update(name: "update_test", image: File.open(image_path)) }.to change(Manufacturer.all, :count).by(0)
    expect(manufacturer.name).to eq "update_test"
    expect(manufacturer.image.url).to eq "/uploads/manufacturer/image/#{manufacturer.id}/default_user.png"
  end
end
