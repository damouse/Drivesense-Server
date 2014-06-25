module TripsHelper
	def get_hours(duration)
		return ((duration/60)/60).floor
	end

	def get_mins(duration)
		return ((duration/60)%60).floor
	end

	def get_secs(duration)
		return (duration%60).floor
	end

end
