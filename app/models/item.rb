class Item < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :content, presence: true, length: { maximum: 300 }
  validates :price, presence: true
  validates :gram, presence: true
  validates :calorie, presence: true
  validates :category_id, presence: true
  validates :manufacturer_id, presence: true
  mount_uploader :image, ImageUploader
  belongs_to :manufacturer, optional: true
  belongs_to :category, optional: true
  has_many :reviews, dependent: :destroy
  has_many :eaten_items, dependent: :destroy
  has_many :want_to_eat_items, dependent: :destroy

  # 商品のレビュースコアの平均点を算出する
  def average_score
    count = reviews.count
    return 0 if count.zero? # 未レビューの場合は、0点とする

    reviews.sum(:score) / count
  end

  # レビューのスコアを集計し、合計ポイント順にidを返す
  def self.popular_ids
    Hash[Item.rank.sort_by { |_, score| -score }].keys
  end

  # 各商品の合計スコアを計算する
  def self.rank
    border_score = 1 # 1点を超えない商品は除く
    weight = -3 # 5点満点のレビューで3点を0点、5点を2点として評価を再マッピングするために使用する
    # 1点がたくさん集まるより、低評価が少なく、高得点のみを獲得している方が評価が高いため

    original_score = Review.group(:item_id).sum(:score) # item_id毎にreviewのスコアを集計
    review_count = Review.group(:item_id).count # item毎のreviewを集計

    total_score = original_score.merge(review_count) { |_key, score, count| score + count * weight } # Σ(review.score - 3)と同じ計算式
    total_score.delete_if do |_key, score|
      score <= border_score # border_score以下のitem取り除く
    end
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
    eaten_count.sort_by { |_, count| -count }.to_h.keys
  end

  # 食べてみたい！の降順にidを返す
  def self.want_to_eat_ids
    want_count = WantToEatItem.group(:item_id).count
    want_count.sort_by { |_, count| -count }.to_h.keys
  end

  # あるタグが付いたレビューを持つ商品を、タグ付け回数の降順に返す
  def self.tagged_desc(tag_name)
    # 対象タグのidを割り出す
    tag_id = ActsAsTaggableOn::Tag.find_by(name: tag_name).id

    # 対象タグの付けられたreviewのidを割り出す
    review_ids = ActsAsTaggableOn::Tagging.where(tag_id: tag_id).pluck(:taggable_id)

    # 対象タグが付いたレビューをitem_id毎に数えることで、itemに対するtag付け回数を計算する
    tag_count = Review.where(id: review_ids).group(:item_id).count

    # item_idの配列を出現回数の降順に並び替え、ハッシュ化してキー(id)を取り出す
    item_ids = tag_count.sort_by { |_, count| -count }.to_h.keys

    # 降順のidでtagを抽出する。orderを明示的に指定しなければ、tag_idsの順番通りにならない
    Item.where(id: item_ids).order([Arel.sql('field(id, ?)'), item_ids])
  end

  # その商品に関連付けられたタグを人気順に返す
  def popular_tags
    # その商品に対するレビューidのみを対象に絞り、各タグの出現回数を調べる
    tag_count = ActsAsTaggableOn::Tagging.where(taggable_id: reviews.ids).group(:tag_id).count

    # tag_idの配列を出現回数の降順に並び替え、ハッシュ化してキー(id)を取り出す
    tag_ids = tag_count.sort_by { |_, count| -count }.to_h.keys

    # 降順のidでtagを抽出する。orderを明示的に指定しなければ、tag_idsの順番通りにならない
    ActsAsTaggableOn::Tag.where(id: tag_ids).order([Arel.sql('field(id, ?)'), tag_ids])
  end

  # 検索機能
  def self.search(keyword)
    search = "%" + keyword + "%"
    # itemの検索範囲は、メーカー名、カテゴリ名、タグ、商品名、商品説明とする
    Item.eager_load(:manufacturer, :category, reviews: :tags).where('items.title like ? or
                                                                     items.content like ? or
                                                                     manufacturers.name like ? or
                                                                     categories.name like ? or
                                                                     tags.name like ?', search, search, search, search, search)
  end
end
