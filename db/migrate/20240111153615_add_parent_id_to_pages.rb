class AddParentIdToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :parent_id, :integer, null: true
    add_foreign_key :pages, :pages, column: :parent_id
    add_index :pages, :parent_id
  end
end
