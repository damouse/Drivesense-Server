class ChangeType < ActiveRecord::Migration
  def change
    rename_column :mappable_events, :type, :pattern_type
  end
end
