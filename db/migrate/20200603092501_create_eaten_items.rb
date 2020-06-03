class CreateEatenItems < ActiveRecord::Migration[5.2]
  def change
    create_table :eaten_items do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end
    change_table :eaten_items, bulk: true do |t|
      t.index %i[user_id item_id], unique: true
    end
  end
end
