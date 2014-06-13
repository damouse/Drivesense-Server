class Trip < ActiveRecord::Base
	has_many :coordinates
	belongs_to :user
    has_one :score
	accepts_nested_attributes_for :coordinates, :score
end
