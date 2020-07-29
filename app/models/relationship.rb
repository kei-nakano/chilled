class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }
  validate :self_follow

  private

  # 自分自身をフォローしていないか検証する
  def self_follow
    return unless follower_id && followed_id

    errors.add(:followed_id, "自分自身をフォローすることはできません") if followed_id == follower_id
  end
end
