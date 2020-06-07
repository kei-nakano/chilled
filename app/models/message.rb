class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_create_commit { MessageBroadcastJob.perform_later self } # メッセージ配信は非同期実行してよいのでperform_later
end
