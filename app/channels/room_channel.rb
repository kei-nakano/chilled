class RoomChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams # 接続ユーザに紐づくすべてのstreamを一度終了する
    stream_from "user_#{current_user.id}"
  end

  def unsubscribed; end

  def speak(data)
    entry = Entry.where(room_id: data['room_id']).where.not(user_id: current_user.id).first
    user = User.find(entry.user_id)
    if current_user.room_id == user.room_id
      Message.create!(user_id: current_user.id, room_id: data['room_id'], content: data['message'], checked: true) # クライアントの画面更新はaftet_commitで行う
    else
      Message.create!(user_id: current_user.id, room_id: data['room_id'], content: data['message'], checked: false) # クライアントの画面更新はaftet_commitで行う
    end
  end

  def destroy(data)
    Message.find(data['message_id']).destroy! # クライアントの画面更新はafter_commitで行う
  end
end
