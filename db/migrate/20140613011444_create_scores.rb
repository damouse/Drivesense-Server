class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.float :score
      t.float :scoreAccels
      t.float :scoreBreaks
      t.float :scoreLaneChanges
      t.float :scoreTurns

      t.timestamps
    end
  end
end