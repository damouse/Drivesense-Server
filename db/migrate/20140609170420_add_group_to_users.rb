class AddGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :group_id, :integer
    add_column :users, :admins_id, :integer
    add_column :users, :invited_id, :integer
  end
end
