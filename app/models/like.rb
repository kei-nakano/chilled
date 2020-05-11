class Like < ApplicationRecord
  validates :user_id,  presence: true
  validates :item_id,  presence: true
end
