class AddLocationToAhoyVisits < ActiveRecord::Migration[7.1]
  def change
    add_column :ahoy_visits, :location, :virtual, type: :string, as: "country || ', ' || region || ', ' || city", stored: true
  end
end
