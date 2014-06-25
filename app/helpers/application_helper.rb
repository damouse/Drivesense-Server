module ApplicationHelper
	def get_owned_group
		return Group.find_by(owner_id: current_user.id)
	end
end
