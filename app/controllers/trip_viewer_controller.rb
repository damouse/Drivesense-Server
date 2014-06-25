class TripViewerController < ApplicationController
	before_action :authenticate_user!


  def all_trips

    unless current_user.invitation_id.nil?
      @inviteGroup = Group.where(id: current_user.invitation_id).first.name
    else
      @inviteGroup = nil
    end

    if params[:id].nil?
      @trips = current_user.trips.order('time_stamp ASC').paginate(:page => params[:page], :per_page => 12)
      @scores = Score.where( trip_id: @trips.map(&:id))
    else
      owned_group = Group.find_by(owner_id: current_user.id)
      unless owned_group.nil?
        if owned_group.id == User.find(params[:id]).group_id
          @trips = User.find(params[:id]).trips.order('time_stamp ASC').paginate(:page => params[:page], :per_page => 12)
          @scores = Score.where( trip_id: @trips.map(&:id))
        else
          redirect_to trips_path, notice: "This user is not a member of your group."
        end
      else
        redirect_to trips_path, notice: "You must own a group to see member trips"
      end
    end
  end

  def trip_viewer
  	@trip = Trip.find(params[:id])
    @scores = Score.where( trip_id: @trip.user.trips.map(&:id))

    contains = false
    if not current_user.group.nil?
      current_user.group.users.each do |member|
        member.trips.each do |trip|
          contains = true if trip.id == @trip.id
        end
      end
    end
    current_user.trips.each do |trip|
      contains = true if trip.id == @trip.id
    end

    unless contains
      redirect_to trips_path, notice: "You can only view trips which belong to you or a member of a group you own."
    end

  	@coordinates = @trip.coordinates.sort_by &:time_stamp
  	@endpoints = [@coordinates.first, @coordinates.last]
  	
  	@hash = Gmaps4rails.build_markers(@endpoints) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
      marker.title "hi"
      
    end
    
    @polylines = Gmaps4rails.build_markers(@coordinates) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
    end    
    
  end
  

  def invalid_trip

  end

end
