class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :title
      t.string :image
      t.references :manufacturer, foreign_key: true
      t.references :category, foreign_key: true
      t.text :content
      t.integer :price
      t.integer :gram
      t.integer :calorie

      t.timestamps
    end
  end
end
