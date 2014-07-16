class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.float :time_stamp
      t.float :lat
      t.float :lon
      t.integer :trip_id

    end
  end
end
