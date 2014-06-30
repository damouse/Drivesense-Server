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
    members = @group.users.order('score.score ASC')
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Member Average Scores")
      f.xAxis(:categories => ["Average Score"])
      members.each do |member|
        scores = Score.where( trip_id: member.trips.map(&:id))
        f.series(:name => member.email, :data => [scores.average(:score).to_f])
      end

      f.yAxis [
        {:title => {:text => "Average Score", :margin => 70} }
      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"column"})
    end
    @chart5 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title({ :text=>"Combination chart"})
      f.options[:xAxis][:categories] = ['Apples', 'Oranges', 'Pears', 'Bananas', 'Plums']
      f.labels(:items=>[:html=>"Total fruit consumption", :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ])
      f.series(:type=> 'column',:name=> 'Jane',:data=> [3, 2, 1, 3, 4])
      f.series(:type=> 'column',:name=> 'John',:data=> [2, 3, 5, 7, 6])
      f.series(:type=> 'column', :name=> 'Joe',:data=> [4, 3, 3, 9, 0])
      f.series(:type=> 'spline',:name=> 'Average', :data=> [3, 2.67, 3, 6.33, 3.33])
      f.series(:type=> 'pie',:name=> 'Total consumption',
        :data=> [
          {:name=> 'Jane', :y=> 13, :color=> 'red'},
          {:name=> 'John', :y=> 23,:color=> 'green'},
          {:name=> 'Joe', :y=> 19,:color=> 'blue'}
        ],
        :center=> [100, 80], :size=> 100, :showInLegend=> false)
    end

    @chart2 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Population vs GDP For 5 Big Countries [2009]")
      f.xAxis(:categories => ["United States", "Japan", "China", "Germany", "France"])
      f.series(:name => "GDP in Billions", :yAxis => 0, :data => [14119, 5068, 4985, 3339, 2656])
      f.series(:name => "Population in Millions", :yAxis => 1, :data => [310, 127, 1340, 81, 65])

      f.yAxis [
        {:title => {:text => "GDP in Billions", :margin => 70} },
        {:title => {:text => "Population in Millions"}, :opposite => true},
      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"column"})
    end

    @chart3 = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
          series = {
                   :type=> 'pie',
                   :name=> 'Browser share',
                   :data=> [
                      ['Firefox', 45.0],
                      ['IE', 26.8],
                      {
                         :name=> 'Chrome',
                         :y=> 12.8,
                         :sliced=> true,
                         :selected=> true
                      },
                      ['Safari', 8.5],
                      ['Opera', 6.2],
                      ['Others', 0.7]
                   ]
          }
          f.series(series)
          f.options[:title][:text] = "THA PIE"
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
          f.plot_options(:pie=>{
            :allowPointSelect=>true,
            :cursor=>"pointer" ,
            :dataLabels=>{
              :enabled=>true,
              :color=>"black",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif"
              }
            }
          })
    end

    @chart4 = LazyHighCharts::HighChart.new('column') do |f|
      f.series(:name=>'John',:data=> [3, 20, 3, 5, 4, 10, 12 ])
      f.series(:name=>'Jane',:data=>[1, 3, 4, 3, 3, 5, 4,-46] )
      f.title({ :text=>"example test title from controller"})
      f.options[:chart][:defaultSeriesType] = "column"
      f.plot_options({:column=>{:stacking=>"percent"}})
    end
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
