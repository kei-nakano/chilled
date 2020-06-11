class Review < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :item
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :review_likes, dependent: :destroy
  has_many :notices, dependent: :destroy

  # ユーザが自分のレビューにいいね！した時の通知を作成する
  def create_notice_review_like(current_user)
    return nil if current_user.id == user_id # 自分で自分のレビューにいいね！した時はnilを返す

    temp = Notice.where(visitor_id: current_user.id, visited_id: user_id, review_id: id, action: 'review_like')
    return if temp.present?

    notice = current_user.active_notices.new(visited_id: user_id, review_id: id, action: 'review_like')
    notice.save if notice.valid?
  end
end
