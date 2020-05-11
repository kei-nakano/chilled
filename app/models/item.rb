class Item < ApplicationRecord
  validates :title, presence: true,
                    length: { maximum: 40 }
  validates :user_id, presence: true

  # DBのリレーション定義後に削除予定
  def user
    User.find(user_id)
  end
end
