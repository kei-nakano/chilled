class MessageDestroyJob < ApplicationJob
  queue_as :default

  def perform(message)
    Entry.where(room_id: message.room_id).each do |entry|
      ActionCable.server.broadcast "user_#{entry.user_id}", message_id: message.id
    end
  end
end
