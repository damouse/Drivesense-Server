$(function(){

  //Demo buttons and function usage
  $('#trips_range').click(function() {
    trips_with_range(['1'], "2014-07-15 20:40:00 -5", '2014-07-20 01:32:44 -5');
  });

  $('#trips_data').click(function() {
    trips_data(['1', '2']);
  });

  //the users associated with the current group can be found as an array within gon.group_users.
  //Only their IDs are present, pass them to trips_with_range to obtain their trips in the appropriate
  //window
  $('#users_group').click(function() {
    for(i = 0; i < gon.group_users.length; i++) {
      var user_id = gon.group_users[i];
      $('#users_group_text').append(user_id).append('<br>');
    }
  });
});

/*
Fetch trips for the given users that match the start date and the end date
Pass the users as an array by ID
Both dates should be in the format 'YYYY-MM-DD HH:MM:SS z'

NOTE: above is dependant on type of date used here. Please make sure the dates respect timezones. Feel
free to change the date format, just make sure its also changed in the rails controller
*/
function trips_with_range(user_ids, start_date, end_date) {
  $.ajax({
      url: '/trips_range',
      type: 'get',
      data: {'users': user_ids, 'start_date': start_date, 'end_date': end_date},
      dataType: 'script',

      complete: function(data){
        $('#trips_range_text').append(data.responseText);
      }
   });
}

/*
Get the scoring and pattern information for the trip
*/
function trips_data(trip_ids) {
  $.ajax({
      url: '/trips_information',
      type: 'get',
      data: {'trips': trip_ids},
      dataType: 'script',

      complete: function(data){
        $('#trips_data_text').append(data.responseText);
      }
   });
}
