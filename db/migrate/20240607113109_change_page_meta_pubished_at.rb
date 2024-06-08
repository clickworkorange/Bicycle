class ChangePageMetaPubishedAt < ActiveRecord::Migration[7.1]
  def change
    rename_column :pages, :meta_pubished_at, :meta_published_at
  end
end
