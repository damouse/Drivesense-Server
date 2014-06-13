class RenameScoreToRawScore < ActiveRecord::Migration
  def change
    rename_column :patterns, :score, :raw_score
  end
end
