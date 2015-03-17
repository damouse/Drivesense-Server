class CreateMappableEvents < ActiveRecord::Migration
  def change
    create_table :mappable_events do |t|
      t.datetime :time_stamp
      # t.datetime :time_stamp_end

      t.float :latitude
      t.float :longitude

      t.float :score

      t.integer :pattern_type
      
      t.integer :trip_id
      t.float :speed
    end

    #temporary while we're straddling databases
    add_column :trips, :scoreAccels, :float
    add_column :trips, :scoreBreaks, :float
    add_column :trips, :scoreLaneChanges, :float
    add_column :trips, :scoreTurns, :float
  end

  add_index :mappable_events, :trip_id
end

#note- pattern_type changed to type, which is now an enum value
#Trip has all the goodies it used to 