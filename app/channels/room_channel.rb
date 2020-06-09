class RoomChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "user_#{current_user.id}"
  end

  def unsubscribed; end

  def speak(data)
    Message.create!(user_id: current_user.id, room_id: data['room_id'], content: data['message'])
  end

  def destroy(data)
    Message.find(data['message_id']).destroy!
  end
end
