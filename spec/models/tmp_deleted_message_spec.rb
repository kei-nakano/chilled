require 'rails_helper'

RSpec.describe TmpDeletedMessage, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:message) { FactoryBot.create(:message) }

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect { FactoryBot.create(:tmp_deleted_message) }.to change(TmpDeletedMessage.all, :count).by(1)
  end

  # user_id、message_idの存在
  describe "presence of user_id, message_id" do
    # user_id、message_idの両方があれば有効な状態であること
    it "is valid with a user_id and message_id" do
      tmp_deleted_message = TmpDeletedMessage.new(user_id: user.id, message_id: message.id)
      expect(tmp_deleted_message).to be_valid
    end

    # user_idがなければ無効な状態であること
    it "is invalid without a user_id" do
      tmp_deleted_message = TmpDeletedMessage.new(user_id: nil, message_id: message.id)
      tmp_deleted_message.valid?
      expect(tmp_deleted_message.errors[:user_id]).to include("を入力してください")
    end

    # message_idがなければ無効な状態であること
    it "is invalid without a message_id" do
      tmp_deleted_message = TmpDeletedMessage.new(user_id: user.id, message_id: nil)
      tmp_deleted_message.valid?
      expect(tmp_deleted_message.errors[:message_id]).to include("を入力してください")
    end
  end

  # 同じメッセージを2回以上hiddenにできないこと
  it "can not create two tmp_deleted_messages for same message" do
    TmpDeletedMessage.create(user_id: user.id, message_id: message.id)
    tmp_deleted_message = TmpDeletedMessage.new(user_id: user.id, message_id: message.id)
    tmp_deleted_message.valid?
    expect(tmp_deleted_message.errors[:message_id]).to include("はすでに存在します")
  end

  # 自分と相手の両者がメッセージを削除したとき、メッセージがDBから削除されること
  it "destroys message when you and other have done them" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    message = FactoryBot.create(:message, user: user1)
    FactoryBot.create(:tmp_deleted_message, user: user1, message: message)
    expect do
      FactoryBot.create(:tmp_deleted_message, user: user2, message: message)
    end.to change(Message.all, :count).by(-1)
    expect(TmpDeletedMessage.count).to eq 0
  end
end
