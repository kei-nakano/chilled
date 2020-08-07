class Review < ApplicationRecord
  validate :image_count
  validate :check_score
  validates :score, presence: true
  validates :content, presence: true, length: { maximum: 300 }
  validates :user_id, presence: true
  validates :item_id, presence: true
  mount_uploaders :multiple_images, MultipleImagesUploader
  acts_as_taggable
  belongs_to :item, optional: true
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  has_many :review_likes, dependent: :destroy
  has_many :notices, dependent: :destroy

  # ユーザが自分のレビューにいいね！した時の通知を作成する
  def create_notice_review_like(review_user)
    return nil if review_user.id == user_id # 自分で自分のレビューにいいね！した時はnilを返す

    # 一度いいね！している場合は通知を作成しない
    temp = Notice.where(visitor_id: review_user.id, visited_id: user_id, review_id: id, action: 'review_like')
    return nil if temp.present?

    notice = review_user.active_notices.new(visited_id: user_id, review_id: id, action: 'review_like')
    notice.save if notice.valid?
  end

  # topページのランキング用に、いいね！とコメントの数を集計し、合計ポイント順にidを返す
  def self.popular_ids
    # 配列をハッシュ化して、スコアが高い順にkeyを取り出す
    Hash[Review.rank.sort_by { |_, score| -score }].keys
  end

  # topページのランキング用に、いいね！とコメントの数を集計し、合計ポイントを計算する
  def self.rank
    like_weight = 4 # 1いいねの重み
    comment_weight = 3 # 1コメントの重み

    # review_id毎にいいねとコメントの数を集計し、ハッシュとして返す
    like_count = ReviewLike.group(:review_id).count
    comment_count = Comment.group(:review_id).count

    # いいね、コメントに重みをかけて、ハッシュのキー毎にスコアを再計算する
    like_count.merge(comment_count) { |_key, like, comment| like * like_weight + comment * comment_weight }
  end

  private

  # アップロード画像が3枚までか検証する
  def image_count
    max = 3
    errors.add(:multiple_images, "は3枚までアップロードできます") if multiple_images.count > max
  end

  # スコアが5点以下か検証する
  def check_score
    return unless score

    errors.add(:score, "は5点以下で入力してください") if score > 5
  end
end
