/* Swedish initialisation for the jQuery UI date picker plugin. */
/* Written by Anders Ekdahl ( anders@nomadiz.se). */
/* Changed by Stefan Pettersson (stefan.pettersson@lumano.se) */
jQuery(function($){
    $.datepicker.regional['sv'] = {
		closeText: 'Stäng',
        prevText: '&laquo;F&ouml;rra',
		nextText: 'N&auml;sta &raquo;',
		currentText: 'Idag',
        monthNames: ['januari','februari','mars','april','maj','juni',
        'juli','augusti','september','oktober','november','december'],
        monthNamesShort: ['jan','feb','mar','apr','maj','jun',
        'jul','aug','sep','okt','nov','dec'],
		dayNamesShort: ['Sön','Mån','Tis','Ons','Tor','Fre','Lör'],
		dayNames: ['s&ouml;ndag','m&aring;ndag','tisdag','onsdag','torsdag','fredag','l&ouml;rdag'],
		dayNamesMin: ['s&ouml;','m&aring;','ti','on','to','fr','l&ouml;'],
		weekHeader: 'v.',
        dateFormat: 'yy-mm-dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
    $.datepicker.setDefaults($.datepicker.regional['sv']);
});