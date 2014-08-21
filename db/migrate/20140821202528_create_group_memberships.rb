class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.timestamps
    end

    create_table :group_admins do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.timestamps
    end

    create_table :group_invites do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.timestamps
    end
  end
end
