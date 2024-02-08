class AddUserToPage < ActiveRecord::Migration[7.1]
  def change
    add_reference :pages, :user, null: true, foreign_key: true
  end
end
