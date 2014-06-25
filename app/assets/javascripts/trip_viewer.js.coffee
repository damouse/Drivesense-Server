jQuery ->
  data = {
    labels : ["Total Score","Brake Score","Acceleration Score","Turn Score","Lane Change Score"],
    datasets : [
      {
        fillColor : "rgba(219,186,52,0.4)",
        strokeColor : "rgba(220,220,220,1)",
        pointColor : "rgba(220,220,220,1)",
        pointStrokeColor : "#fff",
        data : $('#scores').data('scores')
        title : "Trip Scores"
      },
      {
        fillColor : "rgba(99,123,133,0.4)",
        strokeColor : "rgba(220,220,220,1)",
        pointColor : "rgba(220,220,220,1)",
        pointStrokeColor : "#fff",
        data : $('#scores').data('averages')
        title : "Average Trip Scores"
      }
    ]
  }
  
  time = {
    labels : ["1", "2", "3", "4"],
    datasets : [ 
      {
        fillColor : "rgba(99,123,133,0.4)",
        strokeColor : "rgba(220,220,220,1)",
        pointColor : "rgba(220,220,220,1)",
        pointStrokeColor : "#fff",
        data : $('#timeVscore').data('scores')
        
      }
    ]
  }

  myNewChart = new Chart($("#canvas").get(0).getContext("2d")).Bar(data)

  timeUser = new Chart($("#time").get(0).getContext("2d")).Line(time)