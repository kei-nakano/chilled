class AddMultipleImagesToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :multiple_images, :json
  end
end
