class AddRoleToImage < ActiveRecord::Migration[7.1]
  def change
    add_column :images, :role, :string
  end
end
