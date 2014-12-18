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
    
    # make_all_trips_charts
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
    if params[:users].blank?
      render json: {status: :bad_request, message: "no users passed"} and return
    end 

    user_ids = params['users']
    start_date = DateTime.strptime(params['start_date'],'%Y-%m-%d %H:%M:%S %z')
    end_date = DateTime.strptime(params['end_date'],'%Y-%m-%d %H:%M:%S %z')

    # trips = User.joins(:trips).includes(trips: [:score, :coordinates]).where(id: user_ids, trips: {time_stamp: start_date..end_date})

    users = User
    .includes(trips: [:score, :coordinates])
    .where(id: user_ids)
    puts 'a'
    render json: {start_date: start_date, end_date: end_date, users: users.as_json(:include => 
        {:trips => 
          {:include => :coordinates}
        }, :only => [:id, :email]
      )} 
    puts 'b'
  end

  #given a set of trips, return the data associated with each: score objects, patterns, and speed
  def trips_information 

    trip_ids = params['trips']

    #Took me two hours to figure this out, so heres the deal for posterity:
    #PG returns a valid, ESCAPED json wrapped in an array (well in this implementation its two arrays
    #, but still). Rails WILL NOT render this json as a string unless it is valid: i.e. starts with a 
    #doublequote or is composable as a hash. Call first.first to access the first element of the 
    #returned array (which is the resulting json) and pass that on to rails

    # render json: trip_ids and return
    q = "select array_to_json(array_agg(mappable_events)) from mappable_events where trip_id in (#{trip_ids});"
    r = ActiveRecord::Base.connection.execute(q).values
    # render plain: r.first.first.class and return
    render json: r.first.first and return
  end
end
