class AddUrlToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :url, :string
  end
end
