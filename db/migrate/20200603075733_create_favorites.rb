class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end
    change_table :favorites, bulk: true do |t|
      t.index %i[user_id item_id], unique: true
    end
  end
end
