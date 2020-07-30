require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item) }
  let(:review) { FactoryBot.create(:review) }
  let(:category) { FactoryBot.create(:category) }
  let(:manufacturer) { FactoryBot.create(:manufacturer) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:item) }.to change(Item.all, :count).by(1)
  end

  # 存在性チェック
  describe "test of presence" do
    before do
      @valid_item = FactoryBot.build(:item, manufacturer: manufacturer, category: category)
    end

    # buildデータが有効であること
    it "is valid with a user_id and item_id, content, score" do
      expect(@valid_item).to be_valid
    end

    # manufacturer_idがなければ無効な状態であること
    it "is invalid without a manufacturer_id" do
      @valid_item.manufacturer_id = nil
      @valid_item.valid?
      expect(@valid_item.errors[:manufacturer_id]).to include("を入力してください")
    end

    # category_idがなければ無効な状態であること
    it "is invalid without a category_id" do
      @valid_item.category_id = nil
      @valid_item.valid?
      expect(@valid_item.errors[:category_id]).to include("を入力してください")
    end

    # contentがなければ無効な状態であること
    it "is invalid without a content" do
      @valid_item.content = nil
      @valid_item.valid?
      expect(@valid_item.errors[:content]).to include("を入力してください")
    end

    # titleがなければ無効な状態であること
    it "is invalid without a title" do
      @valid_item.title = nil
      @valid_item.valid?
      expect(@valid_item.errors[:title]).to include("を入力してください")
    end

    # gramがなければ無効な状態であること
    it "is invalid without a gram" do
      @valid_item.gram = nil
      @valid_item.valid?
      expect(@valid_item.errors[:gram]).to include("を入力してください")
    end

    # calorieがなければ無効な状態であること
    it "is invalid without a calorie" do
      @valid_item.calorie = nil
      @valid_item.valid?
      expect(@valid_item.errors[:calorie]).to include("を入力してください")
    end

    # priceがなければ無効な状態であること
    it "is invalid without a price" do
      @valid_item.price = nil
      @valid_item.valid?
      expect(@valid_item.errors[:price]).to include("を入力してください")
    end

    # contentがなければ無効な状態であること
    it "is invalid without a content" do
      @valid_item.content = nil
      @valid_item.valid?
      expect(@valid_item.errors[:content]).to include("を入力してください")
    end
  end

  # タイトルの長さ
  describe "length of title" do
    # 31文字のタイトルは無効であること
    it "is invalid with a title which has over 31 characters" do
      item.title = "あ" * 31
      item.valid?
      expect(item.errors[:title]).to include("は30文字以内で入力してください")
    end

    # 30文字のタイトルは有効であること
    it "is valid with a title which has 30 characters" do
      item.title = "あ" * 30
      expect(item).to be_valid
    end
  end

  # 内容の長さ
  describe "length of content" do
    # 301文字の内容は無効であること
    it "is invalid with a content which has over 301 characters" do
      item.content = "あ" * 301
      item.valid?
      expect(item.errors[:content]).to include("は300文字以内で入力してください")
    end

    # 300文字の内容は有効であること
    it "is valid with a content which has 300 characters" do
      item.content = "あ" * 300
      expect(item).to be_valid
    end
  end

  # 画像のアップロード
  describe "check image upload" do
    # 画像なしでも有効であること
    it "is valid with no image" do
      item = FactoryBot.build(:item, manufacturer: manufacturer, category: category, image: nil)
      expect(item).to be_valid
    end

    # 画像なしの場合、デフォルト画像が設定されること
    it "has a default image with no image" do
      item = FactoryBot.build(:item, manufacturer: manufacturer, category: category, image: nil)
      expect(item.image.url).to eq "/default/no_image.png"
    end

    # デフォルト画像以外の画像を設定できること
    it "can set an image except default image" do
      image_path = Rails.root.join("public/default/default_user.png")
      item = FactoryBot.build(:item, manufacturer: manufacturer, category: category, image: File.open(image_path))
      item.save
      expect(item.image.url).to eq "/uploads/item/image/#{item.id}/default_user.png"
    end
  end

  # 商品の平均スコア算出
  describe "calculate average_score of item" do
    # レビュー数0の場合、0点となること
    it "returns 0 when it has no reviews" do
      expect(item.average_score).to eq 0
    end

    # 平均を正しく計算できること
    it "can calculate average score successfully" do
      # 1~5点のレビューを作成
      (1..5).each do |i|
        FactoryBot.create(:review, item: item, score: i)
      end
      expect(item.average_score).to eq 3
    end
  end

  # ランキング機能
  describe "rank" do
    before do
      # itemを3つ生成
      3.times { FactoryBot.create(:item) }
      @item1 = Item.first
      @item2 = Item.second
      @item3 = Item.third

      # item1には3点のレビューを2つ、4点のレビューを1つ与える
      #  ポイントは1
      2.times { FactoryBot.create(:review, item: @item1, score: 3) }
      FactoryBot.create(:review, item: @item1, score: 4)

      # item2には5点のレビューを3つ与える
      # ポイントは6
      3.times { FactoryBot.create(:review, item: @item2, score: 5) }

      # item3には4点のレビューを3つ与える
      # ポイントは3
      3.times { FactoryBot.create(:review, item: @item3, score: 4) }
    end

    # ランクのスコアを正しく計算できること
    it "can calculate rank score successfully" do
      # border 1点以下の場合はnilを返す
      expect(Item.rank[@item1.id]).to eq nil
      expect(Item.rank[@item2.id]).to eq 6
      expect(Item.rank[@item3.id]).to eq 3
    end

    # ランクのスコア順にidを返すこと
    it "returns ids in descending order of score" do
      # 予想では、item2 item3の順
      popular_ids = [@item2.id, @item3.id]
      expect(Item.popular_ids).to eq popular_ids
    end
  end

  # 内容量(g)を単価で割った値が大きい順にidを返す
  it "returns ids in descending order of gram / price" do
    (1..3).each do |i| # idの降順に評価値が下がるように設定
      FactoryBot.create(:item, price: 100 + i)
    end
    reasonable_ids = Item.all.ids
    expect(Item.reasonable_ids).to eq reasonable_ids
  end

  # 食べた！の降順にidを返す
  it "returns ids in descending order of eaten_items" do
    2.times { FactoryBot.create(:item) }
    FactoryBot.create(:eaten_item, item: Item.first)
    2.times { FactoryBot.create(:eaten_item, item: Item.second) }

    # 予想ではidの降順を返す
    eaten_ids = Item.all.order(id: :desc).ids
    expect(Item.eaten_ids).to eq eaten_ids
  end

  # 食べてみたい！の降順にidを返す
  it "returns ids in descending order of want_to_eat_items" do
    2.times { FactoryBot.create(:item) }
    FactoryBot.create(:want_to_eat_item, item: Item.first)
    2.times { FactoryBot.create(:want_to_eat_item, item: Item.second) }

    # 予想ではidの降順を返す
    want_to_eat_ids = Item.all.order(id: :desc).ids
    expect(Item.want_to_eat_ids).to eq want_to_eat_ids
  end

  # 削除の依存関係
  describe "dependent: destoy" do
    # 削除すると、紐づくreviewも全て削除されること
    it "destroys all reviews when deleted" do
      2.times { FactoryBot.create(:review, item: item) }
      expect { item.destroy }.to change(Review.all, :count).by(-2)
    end

    # 削除すると、紐づくeaten_itemも全て削除されること
    it "destroys all eaten_item when deleted" do
      2.times { FactoryBot.create(:eaten_item, item: item) }
      expect { item.destroy }.to change(EatenItem.all, :count).by(-2)
    end

    # 削除すると、紐づくwant_to_eat_itemも全て削除されること
    it "destroys all want_to_eat_item when deleted" do
      2.times { FactoryBot.create(:want_to_eat_item, item: item) }
      expect { item.destroy }.to change(WantToEatItem.all, :count).by(-2)
    end
  end
end
