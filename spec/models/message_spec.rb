require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room) }
  let(:message) { FactoryBot.create(:message) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:message) }.to change(Message.all, :count).by(1)
  end

  # user_id、room_id、contentの存在
  describe "presence of user_id, room_id, content" do
    # user_id、item_id, contentの全てがあれば有効な状態であること
    it "is valid with a user_id and item_id, content" do
      message = Message.new(user_id: user.id, room_id: room.id, content: "test")
      expect(message).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      message = Message.new(user_id: nil, room_id: room.id, content: "test")
      message.valid?
      expect(message.errors[:user_id]).to include("を入力してください")
    end

    # room_idがなければ無効な状態であること
    it "is invalid without a room_id" do
      message = Message.new(user_id: user.id, room_id: nil, content: "test")
      message.valid?
      expect(message.errors[:room_id]).to include("を入力してください")
    end

    # contentがなければ無効な状態であること
    it "is invalid without a content" do
      message = Message.new(user_id: user.id, room_id: room.id, content: nil)
      message.valid?
      expect(message.errors[:content]).to include("を入力してください")
    end
  end

  # メッセージの長さ
  describe "length of message" do
    # 201文字のメッセージは無効であること
    it "is invalid with a message which has over 201 characters" do
      message.content = "あ" * 201
      message.valid?
      expect(message.errors[:content]).to include("は200文字以内で入力してください")
    end

    # 200文字のメッセージは有効であること
    it "is valid with a message which has 200 characters" do
      message.content = "あ" * 200
      expect(message).to be_valid
    end
  end

  # checkedにデフォルトでfalseが設定されること
  it "sets false as checked when it has nothing" do
    Message.create(content: "test", user_id: user.id, room_id: room.id)
    expect(Message.last.checked).to eq false
  end
end
