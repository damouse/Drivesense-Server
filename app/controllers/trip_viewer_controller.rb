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

    render json: {result: users.as_json(:include => 
        {:trips => 
          {:include => :coordinates}
        }
      )} 
  end

  #given a set of trips, return the data associated with each: score objects, patterns, and speed
  def trips_information 
    trip_ids = params['trips']

    trips = Array.new
    Trip.includes([:coordinates, :score]).find(trip_ids).each do |trip|
        trips.push(trip)
        puts '4'
    end

    render :json => {trips: trips.as_json(:include => 
          {:score => {:include => 
            {:patterns=> {:only => 
              [:pattern_type, :raw_score, :start_time, :end_time, :gps_index_start, :gps_index_end]}
            }
          }
        }
      )}
    puts '5'
  end


  private
  #return a json with the user's information and their trips that match the start and end date
  def trips_for_user_window user, start_date, end_date
    trips = user.trips.where(time_stamp: start_date..end_date)
    ret = {id: user.id, email: user.email, trips: trips.as_json(:include => 
      {:coordinates => {except: [:id, :trip_id]}}
      )}
  end
end