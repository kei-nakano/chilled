class Item < ApplicationRecord
  #  validates :title, presence: true,
  #                    length: { maximum: 40 }
  #  validates :user_id, presence: true
  mount_uploader :image, ImageUploader
  has_many :reviews, dependent: :destroy
  belongs_to :manufacturer
  belongs_to :category
  
  # 商品のレビュースコアの平均点を算出する
  def average_score
    reviews.sum(:score) / reviews.count
  end
end


