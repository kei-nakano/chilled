class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 200 }

  after_create_commit { MessageBroadcastJob.perform_later self }
  after_destroy_commit { MessageDestroyJob.perform_now self }
end
