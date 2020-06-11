class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :review_id
      t.integer :comment_id
      t.string :action, default: '', null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
    change_table :notices, bulk: true do |t|
      t.index :visitor_id
      t.index :visited_id
      t.index :review_id
      t.index :comment_id
    end
  end
end
