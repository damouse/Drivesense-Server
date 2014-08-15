class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :pattern_type
      t.float :start_time
      t.float :end_time
      t.float :raw_score

      t.integer :score_id

      t.integer :gps_index_start
      t.integer :gps_index_end

      t.timestamps
    end
  end
end
