class ChangeTimeToTimestamp < ActiveRecord::Migration
  def change
    change_column :patterns, :start_time, :timestamp
    change_column :patterns, :end_time, :timestamp
  end
end
