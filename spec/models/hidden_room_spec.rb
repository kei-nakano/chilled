require 'rails_helper'

RSpec.describe HiddenRoom, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:hidden_room) }.to change(HiddenRoom.all, :count).by(1)
  end

  # user_id、room_idの存在
  describe "presence of user_id, room_id" do
    # user_id、room_idの両方があれば有効な状態であること
    it "is valid with a user_id and room_id" do
      hidden_room = HiddenRoom.new(user_id: user.id, room_id: room.id)
      expect(hidden_room).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      hidden_room = HiddenRoom.new(user_id: nil, room_id: room.id)
      hidden_room.valid?
      expect(hidden_room.errors[:user_id]).to include("を入力してください")
    end

    # room_idがなければ無効な状態であること
    it "is invalid without a room_id" do
      hidden_room = HiddenRoom.new(user_id: user.id, room_id: nil)
      hidden_room.valid?
      expect(hidden_room.errors[:room_id]).to include("を入力してください")
    end
  end

  # 同じルームを2回以上hiddenにできないこと
  it "can not create two hidden_rooms for same room" do
    HiddenRoom.create(user_id: user.id, room_id: room.id)
    hidden_room = HiddenRoom.new(user_id: user.id, room_id: room.id)
    hidden_room.valid?
    expect(hidden_room.errors[:room_id]).to include("はすでに存在します")
  end

  # 作成と削除ができること
  it "can create and destroy" do
    expect { FactoryBot.create(:hidden_room) }.to change(HiddenRoom.all, :count).by(1)
    expect { HiddenRoom.first.destroy }.to change(HiddenRoom.all, :count).by(-1)
  end
end
