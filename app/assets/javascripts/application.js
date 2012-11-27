//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require h5bp
//= require jquery.ui.datepicker-sv
//= require gmaps4rails/gmaps4rails.base
//= require gmaps4rails/gmaps4rails.googlemaps

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function toggle() {
	var ele = document.getElementById("toggle_text");
	var text = document.getElementById("display_text");
	if(ele.style.display == "block") {
    		ele.style.display = "none";
		text.innerHTML = "Mejla";
  	}
	else {
		ele.style.display = "block";
		text.innerHTML = "Ta bort mejlformuläret";
	}
}


$('#hide_optional_link').toggle(function () {
    $(".optional").addClass("optional-hidden");
    document.getElementById("hide_optional_link").innerHTML = "Visa alla frivilliga fält.";
}, function () {
    $(".optional").removeClass("optional-hidden");
    document.getElementById("hide_optional_link").innerHTML = "Dölj alla frivilliga fält.";
});



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
 $("#to").datepicker();
 $("#from").datepicker();
});
