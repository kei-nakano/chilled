class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    Entry.where(room_id: message.room_id).each do |entry|
      if message.user_id == entry.user_id
        ActionCable.server.broadcast "user_#{entry.user_id}", message: my_message(message), room_id: message.room_id, flag: "my"
      else
        ActionCable.server.broadcast "user_#{entry.user_id}", message: other_message(message), room_id: message.room_id, flag: "other"
      end
    end
  end

  private

  def my_message(message)
    ApplicationController.renderer.render(partial: 'messages/my_message', locals: { message: message })
  end

  def other_message(message)
    ApplicationController.renderer.render(partial: 'messages/other_message', locals: { message: message })
  end
end
