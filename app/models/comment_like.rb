class CommentLike < ApplicationRecord
  validates :user_id, presence: true
  validates :comment_id, presence: true
  validates :comment_id, uniqueness: { scope: :user_id }
  belongs_to :user, optional: true
  belongs_to :comment, optional: true
end
