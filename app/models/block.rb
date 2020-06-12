class Block < ApplicationRecord
  belongs_to :from, class_name: "User"
  belongs_to :blocked, class_name: "User"
  validates :from_id, presence: true
  validates :blocked_id, presence: true
  validates :from_id, uniqueness: { scope: :blocked_id }
end
