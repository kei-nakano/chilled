class CreateTmpDeletedMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :tmp_deleted_messages do |t|
      t.references :user, foreign_key: true
      t.references :message, foreign_key: true

      t.timestamps
    end
    change_table :tmp_deleted_messages, bulk: true do |t|
      t.index %i[user_id message_id], unique: true
    end
  end
end
