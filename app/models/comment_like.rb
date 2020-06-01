class CommentLike < ApplicationRecord
  validates :user_id, presence: true
  validates :comment_id, presence: true
  validates :user_id, uniqueness: { scope: :comment_id }
  belongs_to :user
  belongs_to :comment
end
