class AddCheckedToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :checked, :boolean, default: false, null: false
  end
end
