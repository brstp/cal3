//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require h5bp
//= require jquery-ui.min
//= require jquery.ui.datepicker-sv
//= require geocode
//= require gmaps4rails/gmaps4rails.base
//= require gmaps4rails/gmaps4rails.googlemaps

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults




$(function() {
$.datepicker.setDefaults({
   maxDate: '+2y',
   showWeek: true,
//   showOn: 'both',
//   buttonImageOnly: false,
//   buttonImage: 'calendar.gif',
//   buttonText: 'Calendar'
});

 $("#event_start_date").datepicker();
 $("#event_stop_date").datepicker();
});

