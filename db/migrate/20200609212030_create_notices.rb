class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|

      t.timestamps
    end
  end
end
