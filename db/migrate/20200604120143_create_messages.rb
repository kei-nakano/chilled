class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.boolean :checked, default: false, null: false
      t.text :content

      t.timestamps
    end
  end
end
