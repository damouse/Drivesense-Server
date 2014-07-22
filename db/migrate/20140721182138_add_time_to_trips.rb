class AddTimeToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :time, :TimeOfDay
  end
end
