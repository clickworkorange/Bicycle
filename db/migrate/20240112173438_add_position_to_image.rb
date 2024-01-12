class AddPositionToImage < ActiveRecord::Migration[7.1]
  def change
    add_column :images, :position, :integer
  end
end
