# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# groups
for i in 0..1
  groups.append Group.create(name: "#{i} Level Group")
end

#Users
for i in 1..5
  users.append User.create({email: "test#{i}@test.com", password: '12345678', password_confirmation: '12345678'})
end

#Sample create using CallHistory Objects
# trip_string = JSON.parse("{\n    \"trip\": {\n        \"time_stamp\": \"Aug 15, 2014 8:49:01 PM\",\n        \"score_attributes\": {\n            \"patterns_attributes\": [\n                {\n                    \"pattern_type\": \"brake\",\n                    \"start_time\": \"Aug 15, 2014 8:49:03 PM\",\n                    \"end_time\": \"Aug 15, 2014 8:49:03 PM\",\n                    \"raw_score\": 0,\n                    \"gps_index_end\": 22,\n                    \"gps_index_start\": 22\n                },\n                {\n                    \"pattern_type\": \"brake\",\n                    \"start_time\": \"Aug 15, 2014 8:49:04 PM\",\n                    \"end_time\": \"Aug 15, 2014 8:49:05 PM\",\n                    \"raw_score\": 54.955982708239155,\n                    \"gps_index_end\": 24,\n                    \"gps_index_start\": 23\n                },\n                {\n                    \"pattern_type\": \"acceleration\",\n                    \"start_time\": \"Aug 15, 2014 8:49:02 PM\",\n                    \"end_time\": \"Aug 15, 2014 8:49:03 PM\",\n                    \"raw_score\": 35.75366787448458,\n                    \"gps_index_end\": 22,\n                    \"gps_index_start\": 20\n                },\n                {\n                    \"pattern_type\": \"acceleration\",\n                    \"start_time\": \"Aug 15, 2014 8:49:03 PM\",\n                    \"end_time\": \"Aug 15, 2014 8:49:04 PM\",\n                    \"raw_score\": 43.42399171954452,\n                    \"gps_index_end\": 23,\n                    \"gps_index_start\": 22\n                },\n                {\n                    \"pattern_type\": \"acceleration\",\n                    \"start_time\": \"Aug 15, 2014 8:49:04 PM\",\n                    \"end_time\": \"Aug 15, 2014 8:49:04 PM\",\n                    \"raw_score\": 52.38370253374525,\n                    \"gps_index_end\": 23,\n                    \"gps_index_start\": 23\n                },\n                {\n                    \"pattern_type\": \"acceleration\",\n                    \"start_time\": \"Aug 15, 2014 8:49:05 PM\",\n                    \"end_time\": \"Aug 15, 2014 8:49:06 PM\",\n                    \"raw_score\": 55.409776456493184,\n                    \"gps_index_end\": 24,\n                    \"gps_index_start\": 24\n                },\n                {\n                    \"pattern_type\": \"turn\",\n                    \"start_time\": \"Aug 15, 2014 8:49:03 PM\",\n                    \"end_time\": \"Aug 15, 2014 8:49:06 PM\",\n                    \"raw_score\": 29.40595249776665,\n                    \"gps_index_end\": 24,\n                    \"gps_index_start\": 22\n                }\n            ],\n            \"scoreAverage\": 50,\n            \"scoreAccels\": 46.742783,\n            \"scoreBreaks\": 27.477991,\n            \"scoreLaneChanges\": 100,\n            \"scoreTurns\": 29.405952\n        },\n        \"coordinates_attributes\": [\n            {\n                \"time_stamp\": \"Aug 15, 2014 8:49:02 PM\",\n                \"longitude\": -89.3965666,\n                \"latitude\": 43.072300266666666,\n                \"speed\": 0,\n                \"gps_id\": 20\n            },\n            {\n                \"time_stamp\": \"Aug 15, 2014 8:49:03 PM\",\n                \"longitude\": -89.3965752,\n                \"latitude\": 43.07138653333333,\n                \"speed\": 0,\n                \"gps_id\": 21\n            },\n            {\n                \"time_stamp\": \"Aug 15, 2014 8:49:04 PM\",\n                \"longitude\": -89.3965838,\n                \"latitude\": 43.0704728,\n                \"speed\": 0,\n                \"gps_id\": 22\n            },\n            {\n                \"time_stamp\": \"Aug 15, 2014 8:49:05 PM\",\n                \"longitude\": -89.3965924,\n                \"latitude\": 43.06955906666667,\n                \"speed\": 0,\n                \"gps_id\": 23\n            },\n            {\n                \"time_stamp\": \"Aug 15, 2014 8:49:06 PM\",\n                \"longitude\": -89.396601,\n                \"latitude\": 43.068645333333336,\n                \"speed\": 0,\n                \"gps_id\": 24\n            }\n        ],\n        \"name\": \"Trip #2\",\n        \"distance\": 0.25230854728521734,\n        \"duration\": 4\n    },\n    \"user\": {\n        \"authentication_token\": \"y5XwJcrxy72Ty75FjsEz\",\n        \"email\": \"test1@test.com\",\n        \"id\": 2\n    }\n}" )

# Trip.create(trip_string['trip'])
# #trip object init
# 4.times do
#   trip = Trip.create(raw_trip)
#   trip.score = Score.create(raw_score)
#   trips.append trip
# end

# #raw json parse and object creation
# raw_patterns.each do |pattern_hash|
#   scores.each do |score|
#     score.patterns.append(Pattern.create(pattern_hash))
#   end
# end

# raw_coordinates.each do |coordinate_hash|
#   trips.each do |trip|
#     trip.coordinates.append(Coordinate.create(coordinate_hash))
#   end
# end

# trips.each do |trip| 
#   trip.score.save
#   trip.save
# end

# trips[0].update_attributes(time_stamp: "Sat, 09 Jan 2014 19:51:10 CST -06:00")
# trips[1].update_attributes(time_stamp: "Fri, 08 Jan 2014 17:51:10 CST -06:00")
# trips[2].update_attributes(time_stamp: "Thursday, 07 Jan 2014 20:51:10 CST -06:00")
# trips[3].update_attributes(time_stamp: "Fri, 09 Jan 2014 11:51:10 CST -06:00")

# users[0].trips.append(trips[0], trips[1])
# users[1].trips.append(trips[2], trips[3])
# users[2].trips.append(trips[1], trips[1])
# users[3].trips.append(trips[2], trips[3])

#create group heirarchy
# groups[0].admins.append(users[0])
# groups[0].children.append(users[1])
# groups[0].children.append(users[2])

# groups[1].admins.append users[3]
# groups[1].children.append users[4]
# groups[1].invited.append users[5]

# groups[0].groups.append groups[1]
