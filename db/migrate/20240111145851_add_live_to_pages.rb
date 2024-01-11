class AddLiveToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :live, :boolean, default: true
  end
end
