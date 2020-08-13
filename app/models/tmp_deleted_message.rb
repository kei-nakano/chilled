class TmpDeletedMessage < ApplicationRecord
  validates :user_id, presence: true
  validates :message_id, presence: true
  validates :message_id, uniqueness: { scope: :user_id }
  belongs_to :user, optional: true
  belongs_to :message, optional: true
  after_create_commit { MessageHiddenJob.perform_now self }
end
