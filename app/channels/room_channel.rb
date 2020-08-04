class RoomChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams # 接続ユーザに紐づくすべてのstreamを一度終了する
    stream_from "user_#{current_user.id}"
  end

  def unsubscribed; end

  def speak(data)
    # 自分以外のエントリーを探す = 相手のエントリーを見つける
    entry = Entry.where(room_id: data['room_id']).where.not(user_id: current_user.id).first
    # 送信相手
    user = User.find(entry.user_id)

    # 自分と相手のroom_idが一致する = 相手が既にルームに入っているなので、既読にする
    # room_id == 0の場合を含めると、相手がroom外でも、jsのバグで自分のroom_idが更新されず0のときに既読となってしまう
    if current_user.room_id == user.room_id && user.room_id != 0
      Message.create!(user_id: current_user.id, room_id: data['room_id'], content: data['message'], checked: true) # クライアントの画面更新はaftet_commitで行う
    else
      Message.create!(user_id: current_user.id, room_id: data['room_id'], content: data['message'], checked: false) # クライアントの画面更新はaftet_commitで行う
    end
  end

  def destroy(data)
    Message.find(data['message_id']).destroy! # クライアントの画面更新はafter_commitで行う
  end
end
