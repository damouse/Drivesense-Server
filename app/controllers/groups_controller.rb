class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :invite, :stats]
  before_action :admin_user, only: [:index]
  before_action :is_group_admin, only: [:edit, :update, :destroy, :show, :invite, :stats]
  before_action :already_owns_group, only: [:new, :create]
  before_action :has_invitation, only: [:accept, :decline]
  before_action :remove_permission, only: [:remove]
  def index
    @groups = Group.all
  end

  def show
    @members = @group.users
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
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
        @group.update_attribute :owner_id, current_user.id
        current_user.update_attribute :group_id, @group.id 
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
        @group.update_attribute :owner_id, current_user.id
        current_user.update_attribute :group_id, @group.id
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.users.each do |user|
      user.update_attribute :group, nil
    end

    User.where(invitation_id: @group.id).each do |user|
      user.update_attribute :invitation_id, nil
    end

    @group.destroy
    respond_to do |format|
      format.html { redirect_to trips_url notice: "Group deleted!" }
      format.json { head :no_content }
    end
  end

  def invite
    if not User.find_by(email: params[:email]).nil?
      if User.find_by(email: params[:email]).update_attribute(:invitation_id, @group.id)
        redirect_to @group, notice: "An invitation was sent to #{params[:email]}."
      else
        redirect_to @group, notice: "A problem occured no invitation sent to #{params[:email]}."
      end
    else
      redirect_to @group, notice: "No user found with email: #{params[:email]}"
    end
  end

  def accept
    current_user.update_attribute :group_id, current_user.invitation_id
    current_user.update_attribute :invitation_id, nil
    redirect_to trips_path, notice: "You are now a member of #{current_user.group.name}"
  end

  def decline
    current_user.update_attribute :invitation_id, nil
    redirect_to trips_path, notice: "Invitation declined."
  end

  def remove
    @member.update_attribute :group, nil
    redirect_to trips_path, notice: "#{@member.email} has been removed."
  end

  def stats
    @members = @group.users
  end

  private

    def admin_user
      unless current_user.admin?
        redirect_to trips_path, notice: "You don't have admin privileges."
      end
    end

    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name)
    end

    def is_group_admin
      unless current_user == Group.find(params[:id]).owner 
        redirect_to trips_path, notice: "You are not the admin for this group."
      end
    end

    def already_owns_group
      unless Group.find_by(owner_id: current_user.id).nil?
        redirect_to Group.find_by(owner_id: current_user.id), notice: "You can only own one group."
      end
    end

    def has_invitation
      if current_user.invitation_id.nil?
        redirect_to trips_path, notice: "You must be invited to a group in order to join."
      end
    end

    def remove_permission
      @member = User.find(params[:id])
      if @member.group.nil?
        redirect_to trips_path, notice: "User has no group to remove."
      elsif (not (@member.group.owner == current_user)) and (not (current_user == @member))
        redirect_to trips_path, notice: "You do not have permission to remove this member."
      end
    end

  end
