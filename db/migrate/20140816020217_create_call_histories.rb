class CreateCallHistories < ActiveRecord::Migration
  def change
    create_table :call_histories do |t|
      t.string :json
      t.timestamps
    end
  end
end
