class Group < ActiveRecord::Base
	has_many :users
	validates :name, presence: true

  has_many :children, class_name: 'User', foreign_key: 'group_id'
  has_many :admins, class_name: 'User', foreign_key: 'admins_id'
  has_many :invited, class_name: 'User', foreign_key: 'invited_id'

  has_many :groups
end
