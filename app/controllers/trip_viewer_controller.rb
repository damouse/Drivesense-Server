class TripViewerController < ApplicationController
	before_action :authenticate_user!


  def all_trips

    unless current_user.invitation_id.nil?
      @inviteGroup = Group.where(id: current_user.invitation_id).first.name
    else
      @inviteGroup = nil
    end

    if params[:id].nil?
      @trips = current_user.trips.order('time_stamp ASC').paginate(:page => params[:page], :per_page => 9)
      @scores = Score.where( trip_id: @trips.map(&:id))
    else
      owned_group = Group.find_by(owner_id: current_user.id)

      unless owned_group.nil?
        if owned_group.id == User.find(params[:id]).group_id
          @trips = User.find(params[:id]).trips.order('time_stamp ASC').paginate(:page => params[:page], :per_page => 9)
          @scores = Score.where( trip_id: @trips.map(&:id))
        else
          redirect_to trips_path, notice: "This user is not a member of your group."
        end

      else
        redirect_to trips_path, notice: "You must own a group to see member trips"
      end

    end
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Scores vs Time")
      dates = []
      @trips.map(&:time_stamp).each {|x| dates.insert(-1,x.strftime('%D'))}
      f.xAxis(:categories => dates)
      f.series(:name => "Individual Trip", :yAxis => 0, :data => @trips.map(&:score).map(&:score))
      averages =[]
      scores = []
      @trips.each do |trip|
        scores.insert(-1, trip.score.score)
        averages.insert(-1, (scores.inject(:+)/scores.count).round(2))
      end
      f.series(:name => "Average Trip", :yAxis => 0, :data => averages)

      f.yAxis [
        {:title => {:text => "Score", :margin => 70} },
      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"line"})
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
      redirect_to trips_path, notice: "You can only view trips which belong to you or a member of a group you own."
    end

  	@coordinates = @trip.coordinates.sort_by &:time_stamp
  	@endpoints = [@coordinates.first, @coordinates.last]
  	
    count = 0
  	@hash = Gmaps4rails.build_markers(@endpoints) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
      if count == 0
        marker.title "Start"
      else
        marker.title "Finish"
      end
      count += 1
      
    end
    
    @polylines = Gmaps4rails.build_markers(@coordinates) do |coord, marker|
      marker.lat coord.latitude
      marker.lng coord.longitude
    end  
    @data = [@scores.average(:score), @scores.average(:scoreBreaks), @scores.average(:scoreAccels), @scores.average(:scoreTurns), @scores.average(:scoreLaneChanges)]
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Score vs Average")
      f.xAxis(:categories => ["Total Score", "Brake Score", "Acceleration Score", "Turn Score", "Lane Change Score"])
      f.series(:name => "This Trip", :data => [@trip.score.score, @trip.score.scoreBreaks, @trip.score.scoreAccels, @trip.score.scoreTurns, @trip.score.scoreLaneChanges])
      f.series(:name => "Average Trip", :data => [@scores.average(:score).to_f, @scores.average(:scoreBreaks).to_f, @scores.average(:scoreAccels).to_f, @scores.average(:scoreTurns).to_f, @scores.average(:scoreLaneChanges).to_f])

      f.yAxis [
        {:title => {:text => "Score", :margin => 70} },

      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"column"})
    end  
    
  end
end

=begin multiple maps

<div style='width: 800px;'>
  <div id="basic_map" style='width: 800px; height: 400px;'></div>
</div>

<% ['map', "basic_map"].each do |name| %>
<script type="text/javascript">
  
    <%=name%> = Gmaps.build('Google');
    <%=name%>.buildMap({ provider: {}, internal: {id: '<%=name%>'}}, function(){
        markers = <%=name%>.addMarkers(<%=raw @hash.to_json %>);
        polyline = <%=name%>.addPolyline(<%=raw @polylines.to_json %>); 
        <%=name%>.bounds.extendWith(polyline);
        <%=name%>.fitMapToBounds();
    });

  
</script>

<% end %>

=end
