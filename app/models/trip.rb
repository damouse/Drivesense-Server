class Trip < ActiveRecord::Base
	has_many :coordinates, :dependent => :delete_all
	belongs_to :user
    has_one :score, :dependent => :destroy
	accepts_nested_attributes_for :coordinates, :score

end
