require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:review) { FactoryBot.create(:review) }
  let(:comment) { FactoryBot.create(:comment) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:comment) }.to change(Comment.all, :count).by(1)
  end

  # user_id、review_id、contentの存在
  describe "presence of user_id, review_id, content" do
    # user_id、item_id, contentの全てがあれば有効な状態であること
    it "is valid with a user_id and item_id, content" do
      comment = Comment.new(user_id: user.id, review_id: review.id, content: "test")
      expect(comment).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      comment = Comment.new(user_id: nil, review_id: review.id, content: "test")
      comment.valid?
      expect(comment.errors[:user_id]).to include("を入力してください")
    end

    # review_idがなければ無効な状態であること
    it "is invalid without a review_id" do
      comment = Comment.new(user_id: user.id, review_id: nil, content: "test")
      comment.valid?
      expect(comment.errors[:review_id]).to include("を入力してください")
    end

    # contentがなければ無効な状態であること
    it "is invalid without a content" do
      comment = Comment.new(user_id: user.id, review_id: review.id, content: nil)
      comment.valid?
      expect(comment.errors[:content]).to include("を入力してください")
    end
  end

  # コメントの長さ
  describe "length of comment" do
    # 201文字のコメントは無効であること
    it "is invalid with a comment which has over 201 characters" do
      comment.content = "あ" * 201
      comment.valid?
      expect(comment.errors[:content]).to include("は200文字以内で入力してください")
    end

    # 200文字のコメントは有効であること
    it "is valid with a comment which has 200 characters" do
      comment.content = "あ" * 200
      expect(comment).to be_valid
    end
  end

  # 依存関係
  it "can create and destroy" do
    expect { FactoryBot.create(:eaten_item) }.to change(EatenItem.all, :count).by(1)
    expect { EatenItem.first.destroy }.to change(EatenItem.all, :count).by(-1)
  end
end
