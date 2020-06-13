class CreateBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :blocks do |t|
      t.integer :from_id
      t.integer :blocked_id

      t.timestamps
    end
    change_table :blocks, bulk: true do |t|
      t.index :from_id
      t.index :blocked_id
      t.index %i[from_id blocked_id], unique: true
    end
  end
end
