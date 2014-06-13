class RemoveIntegerReplaceWithFloat < ActiveRecord::Migration
  def change
    remove_column :patterns, :start_time
    remove_column :patterns, :end_time

    add_column :patterns, :start_time, :float
    add_column :patterns, :end_time, :float
  end
end
