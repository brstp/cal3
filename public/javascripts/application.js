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

<<<<<<< HEAD

=======
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
>>>>>>> 52fb5f8a1b150943964fc4f3fb5bf37fa1536c27
