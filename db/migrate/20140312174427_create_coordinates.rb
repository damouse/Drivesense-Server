class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.timestamp :time_stamp
      t.float :lat
      t.float :lon
      t.integer :trip_id

      t.timestamps
    end
  end
end
