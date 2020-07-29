require 'rails_helper'

RSpec.describe EatenItem, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    FactoryBot.create(:eaten_item)
    expect { FactoryBot.create(:eaten_item) }.to change(EatenItem.all, :count).by(1)
  end

  # user_id、item_idの存在
  describe "presence of user_id, item_id" do
    # user_id、item_idの両方があれば有効な状態であること
    it "is valid with a user_id and item_id" do
      eaten_item = EatenItem.new(user_id: user.id, item_id: item.id)
      expect(eaten_item).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      eaten_item = EatenItem.new(user_id: nil, item_id: item.id)
      eaten_item.valid?
      expect(eaten_item.errors[:user_id]).to include("を入力してください")
    end

    # item_idがなければ無効な状態であること
    it "is invalid without a item_id" do
      eaten_item = EatenItem.new(user_id: user.id, item_id: nil)
      eaten_item.valid?
      expect(eaten_item.errors[:item_id]).to include("を入力してください")
    end
  end

  # 同じ商品を2回以上食べた！できないこと
  it "can not create two eaten_items for same item" do
    EatenItem.create(user_id: user.id, item_id: item.id)
    eaten_item = EatenItem.new(user_id: user.id, item_id: item.id)
    eaten_item.valid?
    expect(eaten_item.errors[:item_id]).to include("はすでに存在します")
  end

  # 作成と削除ができること
  it "can create and destroy" do
    expect { FactoryBot.create(:eaten_item) }.to change(EatenItem.all, :count).by(1)
    expect { EatenItem.first.destroy }.to change(EatenItem.all, :count).by(-1)
  end
end
