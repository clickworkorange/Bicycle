class AddWidthAndHeightAndAspectToImage < ActiveRecord::Migration[7.1]
  def change
    add_column :images, :width, :integer
    add_column :images, :height, :integer
    add_column :images, :aspect, :string
  end
end
