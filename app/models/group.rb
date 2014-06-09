class Group < ActiveRecord::Base
	has_many :users
	belongs_to :owner, :class_name => "User"
end
