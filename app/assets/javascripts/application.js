//= require jquery
//= require jquery_ujs
//= require h5bp
//= require jquery-ui.min
//= require jquery.ui.datepicker-sv.js


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


function toggle() {
	var ele = document.getElementById("toggleText");
	var text = document.getElementById("displayText");
	if(ele.style.display == "block") {
    		ele.style.display = "none";
		text.innerHTML = "Mejla till evenemangets kontaktperson";
  	}
	else {
		ele.style.display = "block";
		text.innerHTML = "Ta bort mejlformuläret";
	}
}
