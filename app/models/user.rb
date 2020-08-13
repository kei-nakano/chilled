class User < ApplicationRecord
  # 属性付与
  attr_accessor :remember_token, :activation_token, :reset_token

  mount_uploader :image, ImageUploader
  has_secure_password

  # コールバック
  before_save { self.email = email.downcase }
  before_create :create_activation_digest
  before_destroy :rooms_destroy_all
  after_create :create_guide_messages

  # バリデーション
  validates :name,  presence: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validate :image_size
  validate :password_regex

  # アソシエーション
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
  has_many :hidden_rooms, dependent: :destroy
  has_many :tmp_deleted_messages, dependent: :destroy
  has_many :active_notices, class_name: 'Notice', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notices, class_name: 'Notice', foreign_key: 'visited_id', dependent: :destroy
  has_many :active_blocks, class_name: 'Block', foreign_key: 'from_id', dependent: :destroy
  has_many :passive_blocks, class_name: 'Block', foreign_key: 'blocked_id', dependent: :destroy
  has_many :blocking, through: :active_blocks, source: :blocked

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
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
    active_blocks.find_by(blocked_id: user.id).destroy if blocking?(user)
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
    # 自分がエントリーしているルームのidを見つける
    room_ids = "SELECT room_id FROM entries WHERE user_id = :user_id"
    # room_idからエントリーを絞り、エントリーしているユーザのidを見つける
    user_ids = "SELECT user_id FROM entries WHERE room_id IN (#{room_ids})"
    # 自分以外のユーザを見つける
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
    # 一致しない場合はnil
    nil
  end

  # ユーザフォロー時の通知を作成する
  def create_notice_follow(follower)
    # 過去にフォローしたことがある場合は、nilを返す
    already_follow = Notice.where(visitor_id: follower.id, visited_id: id, action: 'follow')
    return nil if already_follow.present?

    notice = follower.active_notices.new(visited_id: id, action: 'follow')
    notice.save if notice.valid?
  end

  # ブロックまたはブロックされているユーザのidを返す
  def block_ids
    active_block_ids = active_blocks.pluck(:blocked_id)
    passive_block_ids = passive_blocks.pluck(:from_id)
    (active_block_ids + passive_block_ids).uniq
  end

  # 非表示にしたルームに対応するユーザidを返す
  def hidden_user_ids
    # 非表示にしたルームのid
    room_ids = HiddenRoom.where(user_id: id).pluck(:room_id)
    # エントリーから、該当するルームに参加していたユーザーのidを見つける
    user_ids = Entry.where(room_id: room_ids).pluck(:user_id)
    # 自分のidを取り除く
    user_ids.delete(id)
    user_ids
  end

  # 検索機能
  def self.search(keyword)
    search = "%" + keyword + "%"
    where('name like ?', search)
  end

  private

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # アップロード画像のサイズを検証する
  def image_size
    errors.add(:image, "は5MB以下にする必要があります") if image.size > 5.megabytes
  end

  # パスワードが正規表現を満たすか確認する
  def password_regex
    valid_password_regex = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)\w{10,20}\z/.freeze
    return nil if valid_password_regex.match(password)

    errors.add(:password, "は半角10~20文字英大文字・小文字・数字をそれぞれ１文字以上含む必要があります")
  end

  # 削除されるユーザが加入していたルームを全て削除する
  def rooms_destroy_all
    rooms.each(&:destroy)
  end

  # ユーザ新規作成後に、このサイトの利用方法についてのメッセージ管理者ユーザから送信する
  def create_guide_messages
    # 管理者ユーザの生成時は何もしない
    return nil if admin? # self.admin?

    # 管理者ユーザの検索
    administrator = User.find_by(email: "admin@example.com", admin: true)
    return nil unless administrator

    # メッセージ作成
    room = Room.create!
    Entry.create!(room_id: room.id, user_id: id)
    Entry.create!(room_id: room.id, user_id: administrator.id)

    Message.create!(user_id: administrator.id,
                    room_id: room.id,
                    content: "Chill℃へようこそ！
                    このサイトは「おいしい冷凍食品の発見」をコンセプトにしたレビューサービスです。")

    Message.create!(user_id: administrator.id,
                    room_id: room.id,
                    content: "「レビューの閲覧・投稿」「検索機能」「食べた・食べたい商品のメモ」「興味のあるユーザへのダイレクトメッセージ」を通じて、「感想や情報をシェアして楽しむツール」としてご利用いただけます。")
  end
end
