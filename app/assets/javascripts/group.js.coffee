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

  myNewChart = new Chart($("#canvas").get(0).getContext("2d")).Bar(data)