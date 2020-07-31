class Block < ApplicationRecord
  belongs_to :from, class_name: "User", optional: true
  belongs_to :blocked, class_name: "User", optional: true
  validates :from_id, presence: true
  validates :blocked_id, presence: true
  validates :blocked_id, uniqueness: { scope: :from_id }
  validate :self_block

  private

  # 自分自身をブロックしていないか検証する
  def self_block
    return unless from_id && blocked_id

    errors.add(:blocked_id, "自分自身をブロックすることはできません") if from_id == blocked_id
  end
end
