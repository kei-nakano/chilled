class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }
  mount_uploader :image, ImageUploader
  validate :image_size
  validates :password, presence: true, length: { minimum: 7 }
  has_secure_password(validations: false)
  before_destroy :rooms_destroy_all
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :review_likes, dependent: :destroy
  has_many :eaten_items, dependent: :destroy
  has_many :want_to_eat_items, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries
  has_many :active_notices, class_name: 'Notice', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notices, class_name: 'Notice', foreign_key: 'visited_id', dependent: :destroy
  has_many :active_blocks, class_name: 'Block', foreign_key: 'from_id', dependent: :destroy
  has_many :passive_blocks, class_name: 'Block', foreign_key: 'blocked_id', dependent: :destroy

  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザがフォローしていたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # フォローしているユーザーと自分のレビューを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Review.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # 過去にメッセージを送ろうとしたことがある（トークルームが作成された）ユーザを返す
  def dm_members
    room_ids = "SELECT room_id FROM entries WHERE user_id = :user_id"
    user_ids = "SELECT user_id FROM entries WHERE room_id IN (#{room_ids})"
    User.where.not(id: id).where("id IN (#{user_ids})", user_id: id)
  end

  # 自分と同じルームを返す
  def room_id(other_user)
    current_user_entries = Entry.where(user_id: id)
    user_entries = Entry.where(user_id: other_user.id)
    current_user_entries.each do |cu_entry|
      user_entries.each do |u_entry|
        return u_entry.room.id if u_entry.room_id == cu_entry.room_id
      end
    end
    nil
  end

  # ユーザフォロー時の通知を作成する
  def create_notice_follow(current_user)
    temp = Notice.where(visitor_id: current_user.id, visited_id: id, action: 'follow')
    return if temp.present?

    notice = current_user.active_notices.new(visited_id: id, action: 'follow')
    notice.save if notice.valid?
  end

  private

  # アップロード画像のサイズを検証する
  def image_size
    errors.add(:image, "should be less than 5MB") if image.size > 5.megabytes
  end

  # 削除されるユーザが加入していたルームを全て削除する
  def rooms_destroy_all
    rooms.each(&:destroy)
  end
end
