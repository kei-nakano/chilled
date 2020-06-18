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

  # レビューのスコアを集計し、合計ポイント順にidを返す
  def self.popular_ids
    total_score = Review.group(:item_id).sum(:score)
    Hash[total_score.sort_by { |_, score| -score }].keys
  end

  # 内容量(g)を単価で割った値が大きい順にidを返す
  def self.reasonable_ids
    gram_hash = Item.pluck(:id, :gram).to_h
    price_hash = Item.pluck(:id, :price).to_h
    cost_performance = gram_hash.merge(price_hash) { |_key, gram, price| gram.to_f / price }
    Hash[cost_performance.sort_by { |_, point| -point }].keys
  end

  # 食べた！の降順にidを返す
  def self.eaten_ids
    eaten_count = EatenItem.group(:item_id).count
    eaten_count.sort_by { |_, v| -v }.to_h.keys
  end

  # 食べてみたい！の降順にidを返す
  def self.want_to_eat_ids
    want_count = WantToEatItem.group(:item_id).count
    want_count.sort_by { |_, v| -v }.to_h.keys
  end

  # あるタグが付いたレビューを持つ商品を、タグ付け回数の降順に返す
  def self.tagged_desc(tag_name)
    tag_id = ActsAsTaggableOn::Tag.find_by(name: tag_name).id
    review_ids = ActsAsTaggableOn::Tagging.where(tag_id: tag_id).pluck(:taggable_id)
    item_count = Review.where(id: review_ids).group(:item_id).count
    item_ids = item_count.sort_by { |_, count| -count }.to_h.keys
    Item.where(id: item_ids).order(['field(id, ?)', item_ids])
  end

  # その商品に関連付けられたタグを人気順に返す
  def popular_tags
    tag_count = ActsAsTaggableOn::Tagging.where(taggable_id: reviews.ids).group(:tag_id).count
    tag_ids = tag_count.sort_by { |_, count| -count }.to_h.keys
    ActsAsTaggableOn::Tag.where(id: tag_ids).order(['field(id, ?)', tag_ids])
  end
end
