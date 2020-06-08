class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    Entry.where(room_id: message.room_id).each do |entry|
      ActionCable.server.broadcast "room_#{entry.user_id}", message: render_message(message)
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/show', locals: { message: message })
  end
end
