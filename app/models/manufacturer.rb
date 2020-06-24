class Manufacturer < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :items, dependent: :destroy
end
