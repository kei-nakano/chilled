class Comment < ApplicationRecord
  belongs_to :review
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
end
