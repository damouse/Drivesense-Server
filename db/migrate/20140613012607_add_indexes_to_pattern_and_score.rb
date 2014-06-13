class AddIndexesToPatternAndScore < ActiveRecord::Migration
  def change
    add_column :scores, :trip_id, :integer
    add_column :patterns, :score_id, :integer
  end
end
