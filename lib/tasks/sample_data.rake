namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  
  	1.times do |n| 
      name  = "trip 1"
      distance = 67.8
      duration  = 3.6
      score = 44
      user_id = 1
      time_stamp = "2014-06-03 12:00:01"
      
      Trip.create!(name: name,
                   distance: distance,
                   duration: duration,
                   score: score, user_id: user_id, time_stamp: time_stamp)
    end
    
    9.times do |n| 
      latitude = "-1#{n}"
      longitude  = "-7#{n}"
      trip_id = 1
      time_stamp = "2014-06-03 12:0#{n}:01"
      
      Coordinate.create!( latitude: latitude,
                   longitude: longitude,
                   trip_id: trip_id, time_stamp: time_stamp)
    end
    
  end 
end
    
    