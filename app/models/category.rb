class Category < ApplicationRecord
  validates :name, presence: true, length: { maximum: 15 }, uniqueness: true
  mount_uploader :image, ImageUploader
  has_many :items, dependent: :destroy
end
