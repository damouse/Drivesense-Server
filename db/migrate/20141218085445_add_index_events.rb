class AddIndexEvents < ActiveRecord::Migration
  def change
    #because its late and i forgot
    add_index :mappable_events, :trip_id
  end
end
