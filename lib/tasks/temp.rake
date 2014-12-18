namespace :temp do
  desc "Migrate temporary models"
  task mig: :environment do
    MappableEvent.all.delete_all

    Trip.all.each do |trip|
      puts "Starting trip #{trip.name}..."

      #copy scores over
      next if trip.score.nil?

      trip.scoreAccels = trip.score.scoreAccels
      trip.scoreBreaks = trip.score.scoreBreaks
      trip.scoreLaneChanges = trip.score.scoreLaneChanges
      trip.scoreTurns = trip.score.scoreTurns

      #eager load the patterns
      patterns = Pattern.where(score_id: trip.score.id)
      events = Array.new

      trip.coordinates.each do |c|
        event = MappableEvent.new(latitude: c.latitude, time_stamp: c.time_stamp, 
          longitude: c.longitude, trip_id: c.trip_id, speed: c.speed)

        events.append event
        pattern = patterns.select {|p| p.gps_index_start == c.gps_id }

        if pattern.empty?
          event.pattern_type = "gps"
        else
          event.pattern_type = pattern.first.pattern_type
          event.score = pattern.first.raw_score
        end
      end

      trip.mappable_events << events
      trip.save
    end
  end
end
