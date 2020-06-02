class CreateReviewLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :review_likes do |t|
      t.references :user, foreign_key: true
      t.references :review, foreign_key: true

      t.timestamps
    end
    change_table :review_likes, bulk: true do |t|
      t.index %i[user_id review_id], unique: true
    end
  end
end
