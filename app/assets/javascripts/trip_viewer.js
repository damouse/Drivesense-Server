$(function(){

  $('#gonTest').click(function() {
    trips_with_range(['1'], "2014-07-15 01:32:44", '2014-07-30 01:32:44');

    // for(i = 0; i < gon.trips.length; i++) {
    //   var trip = gon.trips[i];

    //   for(j = 0; j < trip.coordinates; j++) {
    //     var coordinate = trip.coordinates[j];
    //     alert(coordinate);
    //   }

    //   $('#text').append(trip.name);
    //   // alert(trip.name);
    // }
  });

  // $('#text').append("HELLO");
});

/*
AJAX call to fetch trips for the given users that match the start date and the end date
Pass the users as an array by ID
Both dates should be in the format 'YYYY-MM-DD HH:MM:SS'
*/
function trips_with_range(users, start_date, end_date) {
  $.ajax({
        url: '/trips_range',
        type: 'get',
        data: {'users': users, 'start_date': start_date, 'end_date': end_date},
        dataType: 'script',

        complete: function(data){
          $('#text').append(data.responseText);
        }
     });
}