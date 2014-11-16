class CreateDeviceLog < ActiveRecord::Migration
  def change
    create_table :device_logs do |t|
      t.integer :udid, :limit => 8
      t.string :ip_address
      t.float :power

      t.string :nickname

      t.timestamps
    end
  end
end
