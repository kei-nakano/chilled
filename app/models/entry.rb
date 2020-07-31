class Entry < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :room, optional: true
  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :room_id, uniqueness: { scope: :user_id }
end
