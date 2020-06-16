class Item < ApplicationRecord
  #  validates :title, presence: true,
  #                    length: { maximum: 40 }
  #  validates :user_id, presence: true
  acts_as_taggable
  mount_uploader :image, ImageUploader
  has_many :reviews, dependent: :destroy
  belongs_to :manufacturer
  belongs_to :category
  has_many :eaten_items, dependent: :destroy
  has_many :want_to_eat_items, dependent: :destroy

  # 商品のレビュースコアの平均点を算出する
  def average_score
    count = reviews.count
    return 0 if count.zero?

    reviews.sum(:score) / count
  end

  # topページのランキング用に、レビューのスコアを集計し、合計ポイント順にidを返す
  def self.popular_ids
    total_score = Review.group(:item_id).sum(:score)
    Hash[total_score.sort_by { |_, score| -score }].keys
  end
end
