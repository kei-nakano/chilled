class ChangeUsersColumns < ActiveRecord::Migration[5.2]
  def up
    change_table :users, bulk: true do |t|
      t.string :password_digest
      t.remove :password
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.remove :password_digest
      t.string :password
    end
  end
end
