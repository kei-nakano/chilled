require 'rails_helper'

RSpec.describe Block, type: :model do
  let(:room) { FactoryBot.create(:room) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    FactoryBot.create(:room)
    expect { FactoryBot.create(:room) }.to change(Room.all, :count).by(1)
  end

  describe "dependent: destoy" do
    # roomを削除すると、紐づくエントリーも全て削除されること
    it "destroys all entries when deleted" do
      2.times { FactoryBot.create(:user) }
      Entry.create(room_id: room.id, user_id: User.first.id)
      Entry.create(room_id: room.id, user_id: User.second.id)

      expect { room.destroy }.to change(Entry.all, :count).by(-2)
    end

    # roomを削除すると、紐づくメッセージも全て削除されること
    it "destroys all messages when deleted" do
      2.times { FactoryBot.create(:user) }
      Message.create(room_id: room.id, user_id: User.first.id, content: "test")
      Message.create(room_id: room.id, user_id: User.second.id, content: "test")

      expect { room.destroy }.to change(Message.all, :count).by(-2)
    end

    # roomを削除すると、紐づくhidden_roomも全て削除されること
    it "destroys all hidden_rooms when deleted" do
      2.times { FactoryBot.create(:user) }
      HiddenRoom.create(room_id: room.id, user_id: User.first.id)
      HiddenRoom.create(room_id: room.id, user_id: User.second.id)

      expect { room.destroy }.to change(HiddenRoom.all, :count).by(-2)
    end
  end
end
