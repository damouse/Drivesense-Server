class TripViewerController < ApplicationController
	# before_action :authenticate_user!

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
    if params[:users].blank?
      render json: {status: :bad_request, message: "no users passed"} and return
    end 

    user_ids = params['users']
    start_date = DateTime.strptime(params['start_date'],'%Y-%m-%d %H:%M:%S %z')
    end_date = DateTime.strptime(params['end_date'],'%Y-%m-%d %H:%M:%S %z')

    # users = User.includes(trips: [:score, :coordinates])
    # .joins(:trips)
    # .where(id: user_ids, trips: {time_stamp: start_date..end_date})

    # render json: {ret: users} and return

    #WORKING VERSION
    users = User
    .includes(trips: [:score, :coordinates])
    .where(id: user_ids)

    #"FINAL" Attempt
    # trips = Trip.includes(:score, :coordinates).where(user_id: user_ids, time_stamp: start_date..end_date)

    # users_trips_hash = {}
    # #pull individual users from the found trips array, remove all other trips that share the same user, and associate 
    # #then within a hash
    # trips.each do |trip|
    #   user = trip.user
    #   if users_trips_hash.has_key? user.name
    #   puts trip`
    # end

    # render json: {status: 'done'} and return
    # render json: {ret: users.as_json(include: [:coordinates, :score])} and return

    # render json: {start_date: start_date, end_date: end_date, users: users.as_json(:include => 
    #     {:trips => 
    #       {:include => 
    #         {:coordinates => {:except => 
    #           [:id, :trip_id]}
    #         }, 
    #         :except => [:id, :user_id]
    #       }
    #     }, 
    #     :only => [:id, :email]
    #   )} 

    render json: {users: users.as_json(include: :trips)}

    #old return format
    # render :json => {users: users, start_date: start_date, end_date: end_date}
  end

  def self.lightning
    #test-- dont instantiate objects, just fetch their hashes
    connection.select_all(select([:latitude, :longitude, :timestamp, :virtual_odometer]).arel).each do |attrs|
      attrs.each_key do |attr|
        attrs[attr] = type_cast_attribute(attr, attrs)
      end
    end
  end
end