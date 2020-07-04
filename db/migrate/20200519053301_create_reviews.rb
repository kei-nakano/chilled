class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.float :score, null: false
      t.text :content, null: false
      t.json :multiple_images

      t.timestamps
    end
    index_length = 150
    change_table :reviews, bulk: true do |t|
      t.index :content, length: index_length
    end
  end
end
