class CreateCommentLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :comment_likes do |t|
      t.references :user, foreign_key: true
      t.references :comment, foreign_key: true

      t.timestamps
    end
    change_table :comment_likes, bulk: true do |t|
      t.index %i[user_id comment_id], unique: true
    end
  end
end
