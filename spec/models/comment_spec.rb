require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:review) { FactoryBot.create(:review) }
  let(:comment) { FactoryBot.create(:comment) }
  let(:comment_like) { FactoryBot.create(:comment_like) }

  # 自分で自分のレビューにコメントしているデモデータ
  let(:self_comment) { FactoryBot.create(:comment, review: self_review, user: user) }
  let(:self_review) { FactoryBot.create(:review, user: user) }

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

  # 削除の依存関係
  describe "dependent: destroy" do
    # コメントを消せば、紐づくいいね!と通知が全て削除されること
    it "destroys comment and notice which has same comment_id when deleted" do
      2.times { FactoryBot.create(:user) }
      CommentLike.create(comment_id: comment.id, user_id: User.first.id)
      CommentLike.create(comment_id: comment.id, user_id: User.second.id)
      comment.create_notice_comment(User.first)
      comment.create_notice_comment(User.second)
      expect { comment.destroy }.to change { CommentLike.count }.by(-2).and change { Notice.count }.by(-2)
    end
  end

  # 通知
  describe "notice" do
    context "action: comment" do
      # 自分のレビューにコメントしても、通知は作成されずnilを返すこと
      it "can not create notice when commented by yourself" do
        expect(self_comment.create_notice_comment(user)).to eq nil
        expect { self_comment.create_notice_comment(user) }.to change(Notice.all, :count).by(0)
      end

      # 他人のレビューへのコメントでは毎回通知が作成されること
      it "can create notice when comented by others" do
        other_user = FactoryBot.create(:user)
        comment1 = FactoryBot.create(:comment, review: self_review, user: other_user)
        expect { comment1.create_notice_comment(other_user) }.to change(Notice.all, :count).by(1)
        comment2 = FactoryBot.create(:comment, review: self_review, user: other_user)
        expect { comment2.create_notice_comment(other_user) }.to change(Notice.all, :count).by(1)
      end
    end

    context "action: comment_like" do
      # 自分のコメントにいいね！しても、通知は作成されずnilを返すこと
      it "can not create notice when comment_liked by yourself" do
        CommentLike.create!(user_id: user.id, comment_id: self_comment.id)
        expect(self_comment.create_notice_comment_like(user)).to eq nil
        expect { self_comment.create_notice_comment_like(user) }.to change(Notice.all, :count).by(0)
      end

      # 他人のコメントへのいいね！では通知が作成され、かつ一度だけしか作成されないこと
      it "can create notice only once when coment_liked by others" do
        other_user = FactoryBot.create(:user)
        other_comment = FactoryBot.create(:comment, user: other_user)
        CommentLike.create!(user_id: user.id, comment_id: other_comment.id)
        expect { other_comment.create_notice_comment_like(user) }.to change(Notice.all, :count).by(1)

        # 削除
        expect { user.comment_likes.destroy_all }.to change(user.comment_likes, :count).by(-1)

        # 再作成
        CommentLike.create!(user_id: user.id, comment_id: other_comment.id)
        expect { other_comment.create_notice_comment_like(user) }.to change(Notice.all, :count).by(0)
      end
    end
  end
end
