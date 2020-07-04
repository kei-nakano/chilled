class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.float :score
      t.text :content
      t.json :multiple_images

      t.timestamps
    end
  end
end
