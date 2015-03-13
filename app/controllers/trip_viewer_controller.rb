class TripViewerController < ApplicationController
  before_action :authenticate_user!
  def all_trips
    #gon testing
    gon.group_users = ['1', '2']

    unless current_user.invitation_id.nil?
      @inviteGroup = Group.where(id: current_user.invitation_id).first.name
    else
      @inviteGroup = nil
    end

    if params[:id].nil?
      @all_trips = current_user.trips.order('time_stamp ASC')
      @trips = current_user.trips.order('time_stamp ASC').paginate(:page => params[:page], :per_page => 6)
      @scores = Score.where( trip_id: @trips.map(&:id))
    else
      owned_group = Group.find_by(owner_id: current_user.id)

      unless owned_group.nil?
        if owned_group.id == User.find(params[:id]).group_id
          @all_trips = User.find(params[:id]).trips.order('time_stamp ASC')
          @trips = User.find(params[:id]).trips.order('time_stamp ASC').paginate(:page => params[:page], :per_page => 6)
          @scores = Score.where( trip_id: @trips.map(&:id))
        else
          redirect_to trips_path, :flash => {:error => "This user is not a member of your group."}
          return
        end

      else
        redirect_to trips_path, :flash => {:error => "You must own a group to see member trips"}
        return
      end
    end
  end

  def trip_viewer
    @trip = Trip.find(params[:id])
    @scores = Score.where( trip_id: @trip.user.trips.map(&:id))

    contains = false
    owned_group = Group.find_by(owner_id: current_user.id)
    unless owned_group.nil?
      owned_group.users.each do |member|
        member.trips.each do |trip|
          contains = true if trip.id == @trip.id
        end
      end
    end

    current_user.trips.each do |trip|
      contains = true if trip.id == @trip.id
    end

    unless contains
      redirect_to trips_path, :flash => {:error => "You can only view trips which belong to you or a member of a group you own."}
      return
    end
  end


  ''' Ajaxy calls from trip viewer '''
  #return all of the trips with the given date range and passed users
  #silently fails if the user ID not found! TODO: show an error
  def trips_range

    #set true to use debug data instead of looking for params
    if false
      user_ids = "2,3"
      # start_date = DateTime.strptime("2014-08-18 00:00:00 -5",'%Y-%m-%d %H:%M:%S %z')
      # end_date = DateTime.strptime('2014-08-20 01:32:44 -5','%Y-%m-%d %H:%M:%S %z')

      start_date = "2014-08-18 00:00:00 -5"
      end_date = "2014-08-20 01:32:44 -5"
    else
      if params[:users].blank? or params[:start_date].blank? or params[:end_date].blank?
        render json: {status: :bad_request, message: "you didnt pass enough data"} and return
      end 

      user_ids = params['users']
      user_ids = user_ids.join(",")
      start_date = DateTime.strptime(params['start_date'],'%Y-%m-%d %H:%M:%S %z')
      end_date = DateTime.strptime(params['end_date'],'%Y-%m-%d %H:%M:%S %z')
      start_date = start_date.strftime('%Y-%m-%d %H:%M:%S %z')
      end_date = end_date.strftime('%Y-%m-%d %H:%M:%S %z')
    end

    #implementation 1- surus gem mapping to PG queries
    # render json: User.where("id in (#{user_ids})").all_json(columns: [:id, :email, :group_id], include: {trips: {include: :mappable_events}})

    #Implementation 2- The raw, slightly more powerful, and impressively verbose 
    q = 'select array_to_json(coalesce(array_agg(row_to_json(t)), \'{}\')) 
          from (SELECT id, email, (select array_to_json(coalesce(array_agg(row_to_json(t)), \'{}\'))
            from (SELECT "trips"."id", "trips"."name", "trips"."time_stamp", "trips"."distance", "trips"."duration", "trips"."score", "trips"."user_id", "trips"."created_at", "trips"."updated_at", "trips"."scoreAccels", "trips"."scoreBreaks", "trips"."scoreLaneChanges", "trips"."scoreTurns", (select array_to_json(coalesce(array_agg(row_to_json(t)), \'{}\'))
            from (SELECT "mappable_events"."id", "mappable_events"."time_stamp", "mappable_events"."latitude", "mappable_events"."longitude", "mappable_events"."score", "mappable_events"."pattern_type", "mappable_events"."trip_id", "mappable_events"."speed"
              FROM "mappable_events"  
              WHERE ("trips"."id"="trip_id")
              ORDER BY time_stamp ASC) t) 
            "mappable_events" FROM "trips"  
          WHERE ("users"."id"="user_id")
          AND "time_stamp" BETWEEN \'' + start_date + '\' AND \'' + end_date + '\') t) 
        "trips" FROM "users"  WHERE (id in (' + user_ids + '))) t'

    r = ActiveRecord::Base.connection.execute(q).values
    render json: r.first.first and return
  end

  def trips_information 
    trip_ids = params['trips']
    #render json: Trip.where("id in (#{trip_ids})").all_json(include: :mappable_events)
    
    #DEBUG- uncomment for testing without providing trip ids in query
    # trip_ids = "8"

    #implementation 2
    q = 'select array_to_json(coalesce(array_agg(row_to_json(t)), \'{}\')) from (SELECT "trips"."id", "trips"."name", "trips"."time_stamp", "trips"."distance", "trips"."duration", "trips"."score", "trips"."user_id", "trips"."created_at", "trips"."updated_at", "trips"."scoreAccels", "trips"."scoreBreaks", "trips"."scoreLaneChanges", "trips"."scoreTurns", (select array_to_json(coalesce(array_agg(row_to_json(t)), \'{}\')) from (SELECT "mappable_events"."id", "mappable_events"."time_stamp", "mappable_events"."latitude", "mappable_events"."longitude", "mappable_events"."score", "mappable_events"."pattern_type", "mappable_events"."trip_id", "mappable_events"."speed" 
      FROM "mappable_events"  WHERE ("trips"."id"="trip_id") ORDER BY time_stamp ASC) t) "mappable_events" FROM "trips"  WHERE (id in (' + trip_ids +'))) t'
    r = ActiveRecord::Base.connection.execute(q).values
    render json: r.first.first and return

    
  end
end

=begin

select array_to_json(coalesce(array_agg(row_to_json(t)), '{}')) 
from (SELECT id, email, group_id, 
(select array_to_json(coalesce(array_agg(row_to_json(t)), '{}')) 
from (SELECT "trips"."id", "trips"."name", "trips"."time_stamp", "trips"."distance", "trips"."duration", "trips"."score", "trips"."user_id", "trips"."created_at", "trips"."updated_at", "trips"."scoreAccels", "trips"."scoreBreaks", "trips"."scoreLaneChanges", "trips"."scoreTurns", (select array_to_json(coalesce(array_agg(row_to_json(t)), '{}'))
from (SELECT "mappable_events"."id", "mappable_events"."time_stamp", "mappable_events"."latitude", "mappable_events"."longitude", "mappable_events"."score", "mappable_events"."pattern_type", "mappable_events"."trip_id", "mappable_events"."speed" FROM "mappable_events"  WHERE ("trips"."id"="trip_id")) t) "mappable_events" 
FROM "trips"  
WHERE ("users"."id"="user_id")) t) 
"trips" FROM "users"  WHERE (id in (3))) t


=end
