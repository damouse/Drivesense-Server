class AddInvitationIdToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :invitation_id, :integer, default: nil
  end
end
