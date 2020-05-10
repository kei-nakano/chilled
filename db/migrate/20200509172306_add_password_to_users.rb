class AddPasswordToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password, :string
  end
end
