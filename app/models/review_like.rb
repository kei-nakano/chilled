class ReviewLike < ApplicationRecord
  validates :user_id, presence: true
  validates :review_id, presence: true
  validates :review_id, uniqueness: { scope: :user_id }
  belongs_to :user, optional: true
  belongs_to :review, optional: true
end
