class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :image

      t.timestamps
    end
    change_table :categories, bulk: true do |t|
      t.index :name, unique: true
    end
  end
end
