class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :invite, :stats]
  before_action :admin_user, only: [:index]
  before_action :has_invitation, only: [:accept, :decline]
  before_action :remove_permission, only: [:remove]
  before_action :group_params, only: [:create]
  
  def index
    @groups = Group.all
  end

  def show
    @members = @group.children 
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

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
    @group.invited << user
    user.check_invitation
    MainMailer.group_invite_notification(user, @group).deliver
    redirect_to @group, :flash => {:success => "An invitation was sent to #{params[:email]}."}
  else

  end

  # def accept
  #   current_user.update_attribute :group_id, current_user.invitation_id
  #   current_user.update_attribute :invitation_id, nil
  #   redirect_to trips_path, :flash => {:success => "You are now a member of #{current_user.group.name}"}
  # end

  # def decline
  #   current_user.update_attribute :invitation_id, nil
  #   redirect_to trips_path, :flash => {:warning => "Invitation declined."}
  # end

  # def remove
  #   @member.update_attribute :group, nil
  #   if current_user.group.nil?
  #     redirect_to trips_path, :flash => {:warning => "#{@member.email} has been removed."}
  #   else
  #     redirect_to current_user.group
  #   end
  # end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name)
    end
  end
