class RemoveTimeFieldsAndReplaceWithIntegers < ActiveRecord::Migration
  def change
    remove_column :patterns, :start_time
    remove_column :patterns, :end_time

    add_column :patterns, :start_time, :integer
    add_column :patterns, :end_time, :integer
  end
end
