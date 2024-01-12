class ChangePageLiveDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default :pages, :live, from: true, to: false
  end
end
