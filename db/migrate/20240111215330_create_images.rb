class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.string :caption
      t.string :alt_text
      t.references :page, null: false, foreign_key: true

      t.timestamps
    end
  end
end
