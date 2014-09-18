class AddIndexes < ActiveRecord::Migration
  def change
    add_index :coordinates, :trip_id
    add_index :trips, :user_id
    add_index :scores, :trip_id
    add_index :patterns, :score_id
  end
end
