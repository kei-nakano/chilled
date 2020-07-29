class CommentLike < ApplicationRecord
  validates :user_id, presence: true
  validates :comment_id, presence: true
  validates :comment_id, uniqueness: { scope: :user_id }
  belongs_to :user
  belongs_to :comment
end
