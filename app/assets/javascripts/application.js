//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require_self
//= require_tree .


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





// Sets the form focus to the first element found in forms[0] that
// is a textfield or text area
$(document).ready(function(){
  if (document.forms[0] == null) return;

  for (var i = 0; i < document.forms[0].elements.length; i++) {
    e = document.forms[0].elements[i];
    if ((e.type == "text") || (e.type == "textarea")) {
      e.focus();
      break;
    }
  }
});