class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :invite, :stats, :remove]
  before_action :group_params, only: [:create]
  
  def index
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.admins << current_user

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, :flash => {:success => 'Group was successfully created.'} }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, :flash => {:success => 'Group was successfully updated.'} }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, :flash => {:warning =>  "Group deleted!"} }
      format.json { head :no_content }
    end
  end

  def invite
    user = User.find_by_email(params[:email])

    #make sure user exists
    if user.nil?
      redirect_to @group, :flash => {:error => "No user found with email: #{params[:email]}"} and return
    end

    #invite the user and notify them over email
    @group.invitees << user
    MainMailer.group_invite_notification(user, @group).deliver
    redirect_to @group, :flash => {:success => "An invitation was sent to #{params[:email]}."}
  else

  end

  def accept
    referring_group = Group.find_by_id(params[:referring_group])

    if referring_group.nil?
      redirect_to groups_path, :flash => {:error => "An error occured. Please try again in a little while."} and return
    end

    referring_group.members << current_user
    referring_group.invitees.delete(current_user)

    redirect_to groups_path, :flash => {:success => "You are now a member of #{referring_group.name}"}
  end

  def decline
    referring_group = Group.find_by_id(params[:referring_group])

    if referring_group.nil?
      redirect_to groups_path, :flash => {:error => "An error occured. Please try again in a little while."} and return
    end

    referring_group.invitees.delete(current_user)
    redirect_to groups_path, :flash => {:success => "You have declined the invitation to #{referring_group.name}"}
  end

  def remove
    @group.members.delete(current_user)

    redirect_to groups_path, :flash => {:warning => "#{current_user.email} has been removed from #{@group.name}"}
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name)
    end
  end
