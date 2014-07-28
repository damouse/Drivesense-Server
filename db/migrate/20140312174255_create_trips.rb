class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.datetime :time_stamp
      t.float :raw_time_stamp
      t.float :distance
      t.float :duration
      t.integer :score

      t.timestamps
    end
  end
end
