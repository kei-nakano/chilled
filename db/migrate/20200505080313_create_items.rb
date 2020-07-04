class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.string :image
      t.references :manufacturer, foreign_key: true
      t.references :category, foreign_key: true
      t.text :content, null: false
      t.integer :price, null: false
      t.integer :gram, null: false
      t.integer :calorie, null: false

      t.timestamps
    end
    index_length = 150
    change_table :items, bulk: true do |t|
      t.index :title, unique: true
      t.index :content, length: index_length
    end
  end
end
