class MessageStatusChangeJob < ApplicationJob
  queue_as :default

  def perform(room_id, user_id)
    ActionCable.server.broadcast "user_#{user_id}", room_id: room_id, flag: "read"
  end
end
