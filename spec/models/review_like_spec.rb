require 'rails_helper'

RSpec.describe ReviewLike, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:review) { FactoryBot.create(:review) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    FactoryBot.create(:relationship)
    expect { FactoryBot.create(:relationship) }.to change(Relationship.all, :count).by(1)
  end

  # user_id、review_idの存在
  describe "presence of user_id, review_id" do
    # user_id、review_idの両方があれば有効な状態であること
    it "is valid with a user_id and review_id" do
      review_like = ReviewLike.new(user_id: user.id, review_id: review.id)
      expect(review_like).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      review_like = ReviewLike.new(user_id: nil, review_id: review.id)
      review_like.valid?
      expect(review_like.errors[:user_id]).to include("を入力してください")
    end

    # review_idがなければ無効な状態であること
    it "is invalid without a review_id" do
      review_like = ReviewLike.new(user_id: user.id, review_id: nil)
      review_like.valid?
      expect(review_like.errors[:review_id]).to include("を入力してください")
    end
  end

  # 同じレビューを2回以上いいね！できないこと
  it "can not create two reviewlikes for same review" do
    ReviewLike.create(user_id: user.id, review_id: review.id)
    review_like = ReviewLike.new(user_id: user.id, review_id: review.id)
    review_like.valid?
    expect(review_like.errors[:review_id]).to include("はすでに存在します")
  end

  # 作成と削除ができること
  it "can create and destroy" do
    expect { FactoryBot.create(:review_like) }.to change(ReviewLike.all, :count).by(1)
    expect { ReviewLike.first.destroy }.to change(ReviewLike.all, :count).by(-1)
  end
end
