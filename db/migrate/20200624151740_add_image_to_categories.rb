class AddImageToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :image, :string
  end
end
