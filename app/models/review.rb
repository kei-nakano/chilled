class Review < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :item
  has_many :comments, dependent: :destroy
end
