class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :pattern_type
      t.datetime :start_time
      t.datetime :end_time
      t.float :raw_score

      t.integer :score_id

      t.integer :gps_index_start
      t.integer :gps_index_end
    end
  end
end
