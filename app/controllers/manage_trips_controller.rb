class ManageTripsController < ApplicationController
  before_action :authenticate_user!

  #return the structure of the user's current scope: 
  #if the user is the admin of a group, return that group 
  #else return the user's trips

  def manage_trips
    gon.current_user = current_user.id 
    gon.groups =  {groups: current_user.as_json(include: :trips)}

    # #is member admin of a group?
    # group = Group.find_by_id(current_user.admins_id)

    # #is user a member of a group?
    # group = Group.find_by_id(current_user.group_id) if group.nil?

    # #user is not a member of any group, return users' trip information
    # if group.nil?
    #   render json: {trips: current_user.trips.to_json} and return
    #   @group_data = current_user.trips.to_json and return
    # end

    #   render :json => {trips: trips.as_json(:include => 
    #     {:score => {:include => 
    #       {:patterns=> {:only => 
    #         [:pattern_type, :raw_score, :start_time, :end_time]}
    #       }
    #     }
    #   }
    # )}
  end 
end 
