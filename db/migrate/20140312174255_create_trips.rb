class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.datetime :time_stamp
      t.float :distance
      t.float :duration

      t.float :score
      t.float :scoreAccels
      t.float :scoreBreaks
      t.float :scoreLaneChanges
      t.float :scoreTurns
      
      t.integer :user_id

      t.timestamps
    end

    add_index :trips, :user_id
  end
end
