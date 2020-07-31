require 'rails_helper'

RSpec.describe Block, type: :model do
  before do
    2.times { FactoryBot.create(:user) }
  end

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    FactoryBot.create(:block)
    expect { FactoryBot.create(:block) }.to change(Block.all, :count).by(1)
  end

  # from_id、blocked_idの存在
  describe "presence of from_id, blocked_id" do
    # from_id、blocked_idの両方があれば有効な状態であること
    it "is valid with a blocked_id and from_id" do
      block = Block.new(blocked_id: User.first.id, from_id: User.second.id)
      expect(block).to be_valid
    end

    # from_idがなければ無効な状態であること
    it "is invalid without a from_id" do
      block = Block.new(blocked_id: User.first.id, from_id: nil)
      block.valid?
      expect(block.errors[:from_id]).to include("を入力してください")
    end

    # blocked_idがなければ無効な状態であること
    it "is invalid without a blocked_id" do
      block = Block.new(blocked_id: nil, from_id: User.first.id)
      block.valid?
      expect(block.errors[:blocked_id]).to include("を入力してください")
    end
  end

  # 自分自身をブロックできないこと
  it "can not block yourself" do
    block = Block.new(blocked_id: User.first.id, from_id: User.first.id)
    block.valid?
    expect(block.errors[:blocked_id]).to include("自分自身をブロックすることはできません")
  end

  # 同じ人を2回以上ブロックできないこと
  it "can not block same person twice" do
    Block.create(blocked_id: User.first.id, from_id: User.second.id)
    block = Block.new(blocked_id: User.first.id, from_id: User.second.id)
    block.valid?
    expect(block.errors[:blocked_id]).to include("はすでに存在します")
  end

  # 作成と削除ができること
  it "can create and destroy" do
    expect { FactoryBot.create(:block) }.to change(Block.all, :count).by(1)
    expect { Block.first.destroy }.to change(Block.all, :count).by(-1)
  end
end
