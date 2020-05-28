class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :image
      t.string :password_digest

      t.timestamps
    end
    change_table :users, bulk: true do |t|
      t.index :email, unique: true
    end
  end
end
