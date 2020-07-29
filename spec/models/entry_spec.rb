require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:entry) }.to change(Entry.all, :count).by(1)
  end

  # user_id、room_idの存在
  describe "presence of user_id, room_id" do
    # user_id、room_idの両方があれば有効な状態であること
    it "is valid with a user_id and room_id" do
      entry = Entry.new(user_id: user.id, room_id: room.id)
      expect(entry).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      entry = Entry.new(user_id: nil, room_id: room.id)
      entry.valid?
      expect(entry.errors[:user_id]).to include("を入力してください")
    end

    # room_idがなければ無効な状態であること
    it "is invalid without a room_id" do
      entry = Entry.new(user_id: user.id, room_id: nil)
      entry.valid?
      expect(entry.errors[:room_id]).to include("を入力してください")
    end
  end

  # 同じルームに対して2度エントリーできないこと
  it "can not create two entries for same room" do
    Entry.create(user_id: user.id, room_id: room.id)
    entry = Entry.new(user_id: user.id, room_id: room.id)
    entry.valid?
    expect(entry.errors[:room_id]).to include("はすでに存在します")
  end

  # 作成と削除ができること
  it "can create and destroy" do
    expect { FactoryBot.create(:entry) }.to change(Entry.all, :count).by(1)
    expect { Entry.first.destroy }.to change(Entry.all, :count).by(-1)
  end
end
