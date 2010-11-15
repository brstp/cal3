// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
$.datepicker.setDefaults({
   maxDate: '+2y',
   showWeek: true,
//   showOn: 'both',
//   buttonImageOnly: false,
 //  buttonImage: 'calendar.gif',
//   buttonText: 'Calendar' 
});

 $("#event_start_date").datepicker();
 $("#event_stop_date").datepicker();
});