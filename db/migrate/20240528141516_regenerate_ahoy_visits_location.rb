class RegenerateAhoyVisitsLocation < ActiveRecord::Migration[7.1]
  def change
    remove_column :ahoy_visits, :location, :virtual
    add_column :ahoy_visits, :location, :virtual, type: :string, as: "COALESCE(country, '?') || ', ' || COALESCE(region, '?') || ', ' || COALESCE(city, '?')", stored: true
  end
end
