class Score < ActiveRecord::Base
    belongs_to :trip
    has_many :patterns

    accepts_nested_attributes_for :patterns
end
