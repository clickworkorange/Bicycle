class AddLftRgtToPage < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :lft, :integer, null: false
    add_column :pages, :rgt, :integer, null: false
    add_index :pages, :lft
    add_index :pages, :rgt
  end
end
