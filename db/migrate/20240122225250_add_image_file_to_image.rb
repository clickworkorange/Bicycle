class AddImageFileToImage < ActiveRecord::Migration[7.1]
  def change
    add_column :images, :image_file, :string
  end
end
