class EatenItem < ApplicationRecord
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :item_id, uniqueness: { scope: :user_id }
  belongs_to :user, optional: true
  belongs_to :item, optional: true
end
