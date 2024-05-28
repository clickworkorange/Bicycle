class ChangeLocationInAhoyVisits < ActiveRecord::Migration[7.1]
  def change
    change_column :ahoy_visits, :location, :virtual, type: :string, as: "COALESCE(country, '?') || ', ' || COALESCE(region, '?') || ', ' || COALESCE(city, '?')", stored: true
  end
end
