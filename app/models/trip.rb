class Trip < ActiveRecord::Base
	has_many :coordinates
	belongs_to :user
	accepts_nested_attributes_for :coordinates
end
