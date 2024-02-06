class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :page, null: false, foreign_key: true, index: true
      t.string :title
      t.string :body
      t.references :user, null: false, foreign_key: true
      t.integer :parent_id, null: true, index: true
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true

      t.timestamps
    end
  end
end
