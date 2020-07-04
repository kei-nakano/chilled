class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :image
      t.string :password_digest, null: false
      t.string :remember_digest
      t.boolean :admin, default: false, null: false
      t.string :activation_digest
      t.boolean :activated, default: false, null: false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.boolean :appear, default: false, null: false
      t.integer :room_id, default: 0, null: false # 0はどのroomにも入っていないことを表す

      t.timestamps
    end
    change_table :users, bulk: true do |t|
      t.index :email, unique: true
      t.index :name
    end
  end
end
