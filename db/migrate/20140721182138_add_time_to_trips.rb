class AddTimeToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :time, :time
  end
end
