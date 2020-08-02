class CreateHiddenRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :hidden_rooms do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
    change_table :hidden_rooms, bulk: true do |t|
      t.index %i[user_id room_id], unique: true
    end
  end
end
