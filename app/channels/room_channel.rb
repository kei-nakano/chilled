class RoomChannel < ApplicationCable::Channel
  def subscribed
    # room_channelのsubscriberに対して情報を送る
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create!(user_id: current_user.id, room_id: data['room_id'], content: data['message'])
  end
end
