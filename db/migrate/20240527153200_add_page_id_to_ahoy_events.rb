class AddPageIdToAhoyEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :ahoy_events, :page_id, :virtual, type: :integer, as: "CAST(properties->>'page_id' AS BIGINT)", stored: true
  end
end
