class Trip < ActiveRecord::Base
	has_many :coordinates
	belongs_to :user
end
