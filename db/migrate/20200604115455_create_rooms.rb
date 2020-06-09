class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms, &:timestamps
  end
end
