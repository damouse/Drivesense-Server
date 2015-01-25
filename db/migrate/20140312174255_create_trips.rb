class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.datetime :time_stamp
      t.float :distance
      t.float :duration

      t.double :score
      t.double :scoreAccels
      t.double :scoreBreaks
      t.double :scoreLaneChanges
      t.double :scoreTurns
      
      t.integer :user_id

      t.timestamps
    end

    add_index :trips, :user_id
    add_index :trips, :group_id
  end
end
