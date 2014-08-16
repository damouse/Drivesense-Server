class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.datetime :time_stamp
      t.float :latitude
      t.float :longitude
      t.integer :trip_id
      t.integer :gps_id
      t.integer :speed

    end
  end
end
