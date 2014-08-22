class Group < ActiveRecord::Base
	validates :name, presence: true

  belongs_to :group

  #Users can fit into three categories in groups, administrators, members, or invitees
  has_many :group_admins
  has_many :admins, through: :group_admins, source: :user

  has_many :group_memberships
  has_many :members, through: :group_memberships, source: :user

  has_many :group_invites
  has_many :invitees, through: :group_invites, source: :user

  has_many :groups
end
