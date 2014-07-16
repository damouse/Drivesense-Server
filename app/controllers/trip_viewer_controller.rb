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
          redirect_to trips_path, :flash => {:error => "This user is not a member of your group."}
        end

      else
        redirect_to trips_path, :flash => {:error => "You must own a group to see member trips"}
      end

    end
    
    make_all_trips_charts
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
    end
    make_trip_viewer_charts
  end
end

private

def make_trip_viewer_charts
  @data = [@scores.average(:score), @scores.average(:scoreBreaks), @scores.average(:scoreAccels), @scores.average(:scoreTurns), @scores.average(:scoreLaneChanges)]
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Score vs Average")
      f.xAxis(:categories => ["Total Score", "Brake Score", "Acceleration Score", "Turn Score", "Lane Change Score"])
      f.series(:name => "This Trip", :data => [@trip.score.scoreAverage, @trip.score.scoreBreaks, @trip.score.scoreAccels, @trip.score.scoreTurns, @trip.score.scoreLaneChanges])
      f.series(:name => "Average Trip", :data => [@scores.average(:score).to_f, @scores.average(:scoreBreaks).to_f, @scores.average(:scoreAccels).to_f, @scores.average(:scoreTurns).to_f, @scores.average(:scoreLaneChanges).to_f])

      f.yAxis [
        {:title => {:text => "Score", :margin => 70} },

      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical')
      f.chart({:type=>"column", :reflow => false, :width => 950})
    end 

    @chart2 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Patterns")
      times = @trip.score.patterns.map(&:start_time).sort
      raw_brakes = @trip.score.patterns.where(:pattern_type => "brake").sort_by(&:start_time)
      brakes = []
      times.each do |time|
        if raw_brakes.map(&:start_time).include? (time)
          brakes.insert(-1, raw_brakes[raw_brakes.map(&:start_time).index(time)].raw_score.round(2))
        else
          brakes.insert(-1, '')
        end
      end

      raw_turns = @trip.score.patterns.where(:pattern_type => "turn").sort_by(&:start_time)
      turns = []
      times.each do |time|
        if raw_turns.map(&:start_time).include? (time)
          turns.insert(-1, raw_turns[raw_turns.map(&:start_time).index(time)].raw_score.round(2))
        else
          turns.insert(-1, '')
        end
      end

      raw_accels = @trip.score.patterns.where(:pattern_type => "acceleration").sort_by(&:start_time)
      accels = []
      times.each do |time|
        if raw_accels.map(&:start_time).include? (time)
          accels.insert(-1, raw_accels[raw_accels.map(&:start_time).index(time)].raw_score.round(2))
        else
          accels.insert(-1, '')
        end
      end

      raw_lanes = @trip.score.patterns.where(:pattern_type => "lane_change").sort_by(&:start_time)
      lanes = []
      times.each do |time|
        if raw_lanes.map(&:start_time).include? (time)
          lanes.insert(-1, raw_lanes[raw_lanes.map(&:start_time).index(time)].raw_score.round(2))
        else
          lanes.insert(-1, '')
        end
      end

      readable_times = []
      times.each { |time| readable_times.insert(-1, Time.at(time).strftime('%r'))}

      f.series(:name => "Brake Event", :data => brakes)
      f.series(:name => "Turn Event", :data => turns)
      f.series(:name => "Acceleration Event", :data => accels)
      f.series(:name => "Lane Change", :data => lanes)
      f.xAxis(:categories => readable_times )

      f.yAxis [
        {:title => {:text => "Event Score", :margin => 70} },

      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"scatter", :reflow => false, :width => 950})
    end
  end

  def make_all_trips_charts
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Scores vs Time")
      dates = []
      @trips.map(&:time_stamp).each {|x| dates.insert(-1, x.strftime('%D'))}
      f.xAxis(:categories => dates)
      f.series(:type => "column", :name => "Individual Trip", :yAxis => 0, :data => @trips.map(&:score).map(&:score))
      averages =[]
      scores = []
      @trips.each do |trip|
        scores.insert(-1, trip.score.scoreAverage)
        averages.insert(-1, (scores.inject(:+)/scores.count).round(2))
      end
      f.series(:name => "Average Trip", :yAxis => 0, :data => averages)

      f.yAxis [
        {:title => {:text => "Score", :margin => 70} },
      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      
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
