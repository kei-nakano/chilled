require 'rails_helper'

RSpec.describe CommentLike, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:comment) { FactoryBot.create(:comment) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:comment_like) }.to change(CommentLike.all, :count).by(1)
  end

  # user_id、comment_idの存在
  describe "presence of user_id, comment_id" do
    # user_id、comment_idの両方があれば有効な状態であること
    it "is valid with a user_id and comment_id" do
      comment_like = CommentLike.new(user_id: user.id, comment_id: comment.id)
      expect(comment_like).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      comment_like = CommentLike.new(user_id: nil, comment_id: comment.id)
      comment_like.valid?
      expect(comment_like.errors[:user_id]).to include("を入力してください")
    end

    # comment_idがなければ無効な状態であること
    it "is invalid without a comment_id" do
      comment_like = CommentLike.new(user_id: user.id, comment_id: nil)
      comment_like.valid?
      expect(comment_like.errors[:comment_id]).to include("を入力してください")
    end
  end

  # 同じコメントを2回以上いいね！できないこと
  it "can not create two comment_likes for same comment" do
    CommentLike.create(user_id: user.id, comment_id: comment.id)
    comment_like = CommentLike.new(user_id: user.id, comment_id: comment.id)
    comment_like.valid?
    expect(comment_like.errors[:comment_id]).to include("はすでに存在します")
  end

  # 作成と削除ができること
  it "can create and destroy" do
    expect { FactoryBot.create(:comment_like) }.to change(CommentLike.all, :count).by(1)
    expect { CommentLike.first.destroy }.to change(CommentLike.all, :count).by(-1)
  end
end
