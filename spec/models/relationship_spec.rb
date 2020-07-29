require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    2.times { FactoryBot.create(:user) }
  end

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    FactoryBot.create(:relationship)
    expect { FactoryBot.create(:relationship) }.to change(Relationship.all, :count).by(1)
  end

  # follower_id、followed_idの存在
  describe "presence of follower_id, followed_id" do
    # follower_id、followed_idの両方があれば有効な状態であること
    it "is valid with a followed_id and follower_id" do
      relationship = Relationship.new(followed_id: User.first.id, follower_id: User.second.id)
      expect(relationship).to be_valid
    end

    # follower_idがなければ無効な状態であること
    it "is invalid without a follower_id" do
      relationship = Relationship.new(followed_id: User.first.id, follower_id: nil)
      relationship.valid?
      expect(relationship.errors[:follower_id]).to include("を入力してください")
    end

    # followed_idがなければ無効な状態であること
    it "is invalid without a followed_id" do
      relationship = Relationship.new(followed_id: nil, follower_id: User.first.id)
      relationship.valid?
      expect(relationship.errors[:followed_id]).to include("を入力してください")
    end
  end

  # 自分自身をフォローできないこと
  it "can not follow yourself" do
    relationship = Relationship.new(followed_id: User.first.id, follower_id: User.first.id)
    relationship.valid?
    expect(relationship.errors[:followed_id]).to include("自分自身をフォローすることはできません")
  end

  # 同じ人を2回以上フォローできないこと
  it "can not follow same person twice" do
    Relationship.create(followed_id: User.first.id, follower_id: User.second.id)
    relationship = Relationship.new(followed_id: User.first.id, follower_id: User.second.id)
    relationship.valid?
    expect(relationship.errors[:followed_id]).to include("はすでに存在します")
  end

  # 作成と削除ができること
  it "can create and destroy" do
    expect { FactoryBot.create(:relationship) }.to change(Relationship.all, :count).by(1)
    expect { Relationship.first.destroy }.to change(Relationship.all, :count).by(-1)
  end
end
