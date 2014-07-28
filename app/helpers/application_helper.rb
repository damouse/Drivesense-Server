module ApplicationHelper
	def get_owned_group
		return Group.find_by(owner_id: current_user.id)
	end

	#Returns the full title on a per-page basis
	def full_title(page_title)
		base_title = "KnowMyDrive"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
