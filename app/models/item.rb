class Item < ApplicationRecord
  #  validates :title, presence: true,
  #                    length: { maximum: 40 }
  #  validates :user_id, presence: true
  acts_as_taggable
  mount_uploader :image, ImageUploader
  has_many :reviews, dependent: :destroy
  belongs_to :manufacturer
  belongs_to :category
  has_many :favorites, dependent: :destroy

  # 商品のレビュースコアの平均点を算出する
  def average_score
    return 0 if reviews.count.zero?

    reviews.sum(:score) / reviews.count
  end
end
