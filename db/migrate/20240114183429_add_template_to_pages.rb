class AddTemplateToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :template, :string
  end
end
