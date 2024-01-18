class AddInMenuToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :in_menu, :boolean
  end
end
