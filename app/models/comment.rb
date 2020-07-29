class Comment < ApplicationRecord
  belongs_to :review
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
  has_many :notices, dependent: :destroy
  validates :user_id, presence: true
  validates :review_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 200 }

  # ユーザが自分のコメントにいいね！した時の通知を作成する
  def create_notice_comment_like(comment_user)
    return nil if comment_user.id == user_id # 自分で自分のコメントにいいね！した時はnilを返す

    temp = Notice.where(visitor_id: comment_user.id, visited_id: user_id, comment_id: id, action: 'comment_like')
    return if temp.present?

    notice = comment_user.active_notices.new(visited_id: user_id, comment_id: id, action: 'comment_like')
    notice.save if notice.valid?
  end

  # ユーザが自分のレビューにコメントした時の通知を作成する
  def create_notice_comment(comment_user)
    return nil if comment_user.id == review.user_id # 自分で自分のレビューにコメントした時はnilを返す

    notice = comment_user.active_notices.new(visited_id: review.user_id, comment_id: id, action: 'comment')
    notice.save if notice.valid?
  end
end
