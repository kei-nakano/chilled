class Comment < ApplicationRecord
  belongs_to :review
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
  has_many :notices, dependent: :destroy

  # ユーザが自分のコメントにいいね！した時の通知を作成する
  def create_notice_comment_like(current_user)
    return nil if current_user.id == user_id # 自分で自分のコメントにいいね！した時はnilを返す

    temp = Notice.where(visitor_id: current_user.id, visited_id: user_id, comment_id: id, action: 'comment_like')
    return if temp.present?

    notice = current_user.active_notices.new(visited_id: user_id, comment_id: id, action: 'comment_like')
    notice.save if notice.valid?
  end

  # ユーザが自分のレビューにコメントした時の通知を作成する
  def create_notice_comment(current_user)
    return nil if current_user.id == review.user_id # 自分で自分のレビューにコメントした時はnilを返す

    notice = current_user.active_notices.new(visited_id: review.user_id, comment_id: id, action: 'comment')
    notice.save if notice.valid?
  end
end
