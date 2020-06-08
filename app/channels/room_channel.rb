class RoomChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "room_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create!(user_id: current_user.id, room_id: data['room_id'], content: data['message'])
  end
end
