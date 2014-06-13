class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :pattern_type
      t.time :start_time
      t.time :end_time
      t.float :score

      t.timestamps
    end
  end
end
