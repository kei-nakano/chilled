class Manufacturer < ApplicationRecord
  validates :name, presence: true, length: { maximum: 15 }
  mount_uploader :image, ImageUploader
  has_many :items, dependent: :destroy
end
