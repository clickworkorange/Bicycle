class AddAbstractToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :abstract, :string
  end
end
