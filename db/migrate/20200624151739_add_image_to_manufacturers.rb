class AddImageToManufacturers < ActiveRecord::Migration[5.2]
  def change
    add_column :manufacturers, :image, :string
  end
end
