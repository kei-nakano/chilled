class Manufacturer < ApplicationRecord
  max_name_chars = 15
  validates :name, presence: true,
                   length: { maximum: max_name_chars },
                   uniqueness: true
  mount_uploader :image, ImageUploader
  has_many :items, dependent: :destroy
end
