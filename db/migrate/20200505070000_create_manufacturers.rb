class CreateManufacturers < ActiveRecord::Migration[5.2]
  def change
    create_table :manufacturers do |t|
      t.string :name

      t.timestamps
    end
    change_table :manufacturers, bulk: true do |t|
      t.index :name
    end
  end
end
