class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  before_destroy :rooms_destroy_all
  validates :name,  presence: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  mount_uploader :image, ImageUploader
  validate :image_size
  validates :password, length: { minimum: 7 }
  has_secure_password
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
  has_many :blocking, through: :active_blocks, source: :blocked

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    if (cost = ActiveModel::SecurePassword.min_cost)
      BCrypt::Engine::MIN_COST
    else
      BCrypt::Engine.cost
    end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # ユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # ユーザーをブロックする
  def block(user)
    active_blocks.create(blocked_id: user.id)
  end

  # ユーザをブロック解除する
  def unblock(user)
    active_blocks.find_by(blocked_id: user.id).destroy
  end

  # ユーザをフォロー解除する
  def unfollow(user)
    return active_relationships.find_by(followed_id: user.id).destroy if following?(user)

    nil
  end

  # ユーザをフォローしていたらtrueを返す
  def following?(user)
    following.include?(user)
  end

  # ユーザをブロックしていたらtrueを返す
  def blocking?(user)
    blocking.include?(user)
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
  def room_with(user)
    current_user_entries = Entry.where(user_id: id)
    user_entries = Entry.where(user_id: user.id)
    current_user_entries.each do |cu_entry|
      user_entries.each do |u_entry|
        return u_entry.room if u_entry.room_id == cu_entry.room_id
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
