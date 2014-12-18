class MappableEvent < ActiveRecord::Base
  enum type: [:acceleration, :brake, :turn, :lanechange, :stop, :gps, :unset]

  belongs_to :trip
end
