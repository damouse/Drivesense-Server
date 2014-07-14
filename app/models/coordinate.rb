class Coordinate < ActiveRecord::Base
	belongs_to :trip
	validates :time_stamp, presence: true
end
