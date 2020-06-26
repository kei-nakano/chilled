class RoomChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams # 接続ユーザに紐づくすべてのstreamを一度終了する
    stream_from "user_#{current_user.id}"
  end

  def unsubscribed; end

  def speak(data)
    Message.create!(user_id: current_user.id, room_id: data['room_id'], content: data['message']) # クライアントの画面更新はaftet_commitで行う
  end

  def destroy(data)
    Message.find(data['message_id']).destroy! # クライアントの画面更新はafter_commitで行う
  end
end
