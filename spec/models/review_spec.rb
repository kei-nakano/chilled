require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item) }
  let(:review) { FactoryBot.create(:review) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:review) }.to change(Review.all, :count).by(1)
  end

  # 存在性チェック
  describe "test of presence" do
    before do
      @valid_review = Review.new(user_id: user.id, item_id: item.id, content: "test", score: 5.0)
    end

    # user_id、item_id、content、scoreの全てがあれば有効な状態であること
    it "is valid with a user_id and item_id, content, score" do
      expect(@valid_review).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      @valid_review.user_id = nil
      @valid_review.valid?
      expect(@valid_review.errors[:user_id]).to include("を入力してください")
    end

    # item_idがなければ無効な状態であること
    it "is invalid without a item_id" do
      @valid_review.item_id = nil
      @valid_review.valid?
      expect(@valid_review.errors[:item_id]).to include("を入力してください")
    end

    # contentがなければ無効な状態であること
    it "is invalid without a content" do
      @valid_review.content = nil
      @valid_review.valid?
      expect(@valid_review.errors[:content]).to include("を入力してください")
    end

    # scoreがなければ無効な状態であること
    it "is invalid without a score" do
      @valid_review.score = nil
      @valid_review.valid?
      expect(@valid_review.errors[:score]).to include("を入力してください")
    end
  end

  # 内容の長さ
  describe "length of content" do
    # 301文字の内容は無効であること
    it "is invalid with a content which has over 301 characters" do
      review.content = "あ" * 301
      review.valid?
      expect(review.errors[:content]).to include("は300文字以内で入力してください")
    end

    # 300文字の内容は有効であること
    it "is valid with a content which has 300 characters" do
      review.content = "あ" * 300
      expect(review).to be_valid
    end
  end

  # スコアの上限確認
  describe "check score limit" do
    # 5点以下なら有効であること
    it "is valid with score less than 5" do
      review = FactoryBot.build(:review, user: user, item: item, score: 5.0)
      expect(review).to be_valid
    end

    # 5点を超えると無効であること
    it "is invalid with score more than 5" do
      review = FactoryBot.build(:review, score: 5.01)
      review.valid?
      expect(review.errors[:score]).to include("は5点以下で入力してください")
    end
  end

  # 画像のアップロード
  describe "check image upload" do
    # 画像なしでも有効であること
    it "is valid with no image" do
      review = FactoryBot.build(:review, user: user, item: item, multiple_images: nil)
      expect(review).to be_valid
    end

    # 画像は3枚まで設定できること
    it "can upload images up to 3" do
      image_path = Rails.root.join("public/default/default_user.png")
      multiple_images = Array.new(3) { File.open(image_path) }
      review = FactoryBot.build(:review, user: user,
                                         item: item,
                                         multiple_images: multiple_images)
      expect(review).to be_valid
    end

    # 画像は4枚設定できないこと
    it "can not upload 4 images" do
      image_path = Rails.root.join("public/default/default_user.png")
      multiple_images = Array.new(4) { File.open(image_path) }
      review = FactoryBot.build(:review, user: user,
                                         item: item,
                                         multiple_images: multiple_images)
      review.valid?
      expect(review.errors[:multiple_images]).to include("は3枚までアップロードできます")
    end
  end

  # タグ付けができること
  it "can add tags" do
    tag_list = Array.new(3) { |n| "#{n + 1}個目のタグ" }
    expect { review.update(tag_list: tag_list) }.to change(ActsAsTaggableOn::Tag, :count).by(3)

    last_id = ActsAsTaggableOn::Tag.last.id
    (1..3).each do |n|
      expect(Review.last.tag_list[n - 1]).to eq "#{n}個目のタグ"
      expect(ActsAsTaggableOn::Tag.find(last_id - n + 1).taggings_count).to eq 1 # 全てのタグのタグ付け回数が1回増加
    end
  end

  # 通知
  describe "notice" do
    context "action: review_like" do
      # 自分のレビューにいいね！しても、通知は作成されずnilを返すこと
      it "can not create notice when liked by yourself" do
        expect(review.create_notice_review_like(review.user)).to eq nil
        expect { review.create_notice_review_like(review.user) }.to change(Notice.all, :count).by(0)
      end

      # 他人のレビューへのコメントでは通知が作成されること
      it "can create notice when liked by others" do
        expect { review.create_notice_review_like(user) }.to change(Notice.all, :count).by(1)
      end

      # 他人のレビューへいいね！と取り消しを繰り返しても通知は1回しか作成されないこと
      it "can create notice only once when liked again and again" do
        expect do
          2.times { review.create_notice_review_like(user) }
        end.to change(Notice.all, :count).by(1)
      end
    end
  end

  # ランキング機能
  describe "rank" do
    before do
      4.times { FactoryBot.create(:review) }
      @first_id = Review.first.id

      # 最初のデータから順に、i回のコメントといいね！を付与
      # 最後のデータから順に高ポイントを獲得する
      (1..4).each do |i|
        i.times do
          FactoryBot.create(:comment, review: Review.find(@first_id + i - 1))
          FactoryBot.create(:review_like, review: Review.find(@first_id + i - 1))
        end
      end
    end

    # ランクのスコアを正しく計算できること
    it "can calculate rank score successfully" do
      like_weight = 4 # 1いいねの重み
      comment_weight = 3 # 1コメントの重み
      (1..4).each do |i|
        score = Review.rank[@first_id + i - 1]
        expect(score).to eq(like_weight * i + comment_weight * i)
      end
    end

    # ランクのスコア順にidを返すこと
    it "can calculate rank score successfully" do
      # 予想では、最後のデータから順に高ポイントとなる
      popular_ids = Array.new(4) { |i| @first_id + 3 - i }
      expect(Review.popular_ids).to eq popular_ids
    end
  end

  # 検索
  describe "search" do
    # 紐づくタグと部分一致する文言があればヒットすること
    it "can search in related tags" do
      2.times { FactoryBot.create(:review) }
      Review.first.update(tag_list: "美味しい")
      Review.second.update(tag_list: "味し")
      expect(Review.search("味し").ids).to eq [Review.first.id, Review.second.id]
    end

    # レビュー内容と部分一致する文言があればヒットすること
    it "can search in its content" do
      2.times { FactoryBot.create(:review) }
      Review.first.update(content: "美味しい")
      Review.second.update(content: "味し")
      expect(Review.search("味し").ids).to eq [Review.first.id, Review.second.id]
    end

    # 商品名と部分一致する文言があればヒットすること
    it "can search in related item name" do
      item1 = FactoryBot.create(:item, title: "テスト商品1")
      2.times { FactoryBot.create(:review, item: item1) }
      expect(Review.search("スト商品").ids).to eq [Review.first.id, Review.second.id]
    end

    # メーカー名と部分一致する文言があればヒットすること
    it "can search in related manufacturer name" do
      manufacturer1 = FactoryBot.create(:manufacturer, name: "テストメーカー1")
      item1 = FactoryBot.create(:item, manufacturer: manufacturer1)
      2.times { FactoryBot.create(:review, item: item1) }
      expect(Review.search("ストメーカー").ids).to eq [Review.first.id, Review.second.id]
    end

    # カテゴリ名と部分一致する文言があればヒットすること
    it "can search in related category name" do
      category1 = FactoryBot.create(:category, name: "テストカテゴリ1")
      item1 = FactoryBot.create(:item, category: category1)
      2.times { FactoryBot.create(:review, item: item1) }
      expect(Review.search("ストカテゴリ").ids).to eq [Review.first.id, Review.second.id]
    end
  end

  # 削除の依存関係
  describe "dependent: destoy" do
    # 削除すると、紐づくcommentも全て削除されること
    it "destroys all comments when deleted" do
      2.times { FactoryBot.create(:comment, review: review) }
      expect { review.destroy }.to change(Comment.all, :count).by(-2)
    end

    # 削除すると、紐づくreview_likeも全て削除されること
    it "destroys all review_likes when deleted" do
      2.times { FactoryBot.create(:review_like, review: review) }
      expect { review.destroy }.to change(ReviewLike.all, :count).by(-2)
    end

    # 削除すると、紐づく通知も全て削除されること
    it "destroys all review_likes when deleted" do
      2.times { FactoryBot.create(:user) }
      review.create_notice_review_like(User.first)
      review.create_notice_review_like(User.second)
      expect { review.destroy }.to change(Notice.all, :count).by(-2)
    end
  end
end
