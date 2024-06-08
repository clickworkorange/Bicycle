class AddMetaTagsToPage < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :meta_description, :string
    add_column :pages, :meta_pubished_at, :datetime
    add_column :pages, :meta_updated_at, :datetime
  end
end
