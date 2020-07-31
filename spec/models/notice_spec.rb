require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    2.times { FactoryBot.create(:user) }
  end

  let(:review) { FactoryBot.create(:review) }
  let(:comment) { FactoryBot.create(:comment) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:message) }.to change(Message.all, :count).by(1)
  end

  # visitor_id、visited_id、actionの存在
  describe "presence of visitor_id, visited_id, action" do
    # visitor_id、visited_id, actionの全てがあれば有効な状態であること
    it "is valid with a visitor_id and visited_id, action" do
      notice = Notice.new(visitor_id: User.first.id, visited_id: User.second.id, action: "follow")
      expect(notice).to be_valid
    end

    # visitor_idがなければ無効な状態であること
    it "is invalid without a visitor_id" do
      notice = Notice.new(visitor_id: nil, visited_id: User.second.id, action: "follow")
      notice.valid?
      expect(notice.errors[:visitor_id]).to include("を入力してください")
    end

    # visited_idがなければ無効な状態であること
    it "is invalid without a visited_id" do
      notice = Notice.new(visitor_id: User.first.id, visited_id: nil, action: "follow")
      notice.valid?
      expect(notice.errors[:visited_id]).to include("を入力してください")
    end

    # actionがなければ無効な状態であること
    it "is invalid without an action" do
      notice = Notice.new(visitor_id: User.first.id, visited_id: User.second.id, action: nil)
      notice.valid?
      expect(notice.errors[:action]).to include("を入力してください")
    end
  end

  # review_idが設定できること
  it "can set review_id" do
    expect do
      Notice.create(visitor_id: User.first.id, visited_id: review.user_id, action: "review_like", review_id: review.id)
    end.to change(Notice.all, :count).by(1)
  end

  # comment_idが設定できること
  it "can set comment_id" do
    expect do
      Notice.create(visitor_id: User.first.id, visited_id: comment.user_id, action: "comment_like", comment_id: comment.id)
    end.to change(Notice.all, :count).by(1)
  end
end
