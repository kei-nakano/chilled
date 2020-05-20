class Item < ApplicationRecord
  #  validates :title, presence: true,
  #                    length: { maximum: 40 }
  #  validates :user_id, presence: true
  mount_uploader :image, ImageUploader
  has_many :reviews, dependent: :destroy
  belongs_to :manufacturer
  belongs_to :category
end
