class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_create_commit { MessageBroadcastJob.perform_later self }
  after_destroy_commit { MessageDestroyJob.perform_now self }
end
