class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    current_user.update_attribute(:appear, true)
  end

  def unsubscribed
    current_user.update_attribute(:appear, false)
  end

  def appear(data)
    current_user.update_attribute(:room_id, data['room_id'])
  end
end
