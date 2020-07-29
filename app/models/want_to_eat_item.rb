class WantToEatItem < ApplicationRecord
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :item_id, uniqueness: { scope: :user_id }
  belongs_to :user
  belongs_to :item
end
