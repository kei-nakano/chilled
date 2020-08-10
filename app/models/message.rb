class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 200 }
  has_many :tmp_deleted_messages, dependent: :destroy

  after_create_commit { MessageBroadcastJob.perform_later self }
end
