class MappableEvent < ActiveRecord::Base
  enum pattern_type: [:acceleration, :brake, :turn, :lanechange, :stop, :gps, :unset]

  belongs_to :trip
end
