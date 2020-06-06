class Review < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :item
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :review_likes, dependent: :destroy
end
