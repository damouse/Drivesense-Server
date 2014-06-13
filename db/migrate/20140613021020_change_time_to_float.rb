class ChangeTimeToFloat < ActiveRecord::Migration
  def change
    change_column :patterns, :start_time, :integer
    change_column :patterns, :end_time, :integer
  end
end
