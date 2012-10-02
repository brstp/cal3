//Useful links:
// http://code.google.com/apis/maps/documentation/javascript/reference.html#Marker
// http://code.google.com/apis/maps/documentation/javascript/services.html#Geocoding
// http://jqueryui.com/demos/autocomplete/#remote-with-cache
      
var geocoder;
var map;
var marker;
    
function initialize(){
//MAP
  var latlng = new google.maps.LatLng(document.getElementById("init_lat").value ,document.getElementById("init_lng").value);
  var initZoom = document.getElementById("init_zoom").value;
  var options = {
    zoom: 4,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
        
  map = new google.maps.Map(document.getElementById("map_edit"), options);
    
  //MARKER
  marker = new google.maps.Marker({
    map: map,
    draggable: true
  });

  if (document.getElementById("init_zoom").value){
    map.setZoom(15);
    var initLocation = new google.maps.LatLng(document.getElementById("init_lat").value ,document.getElementById("init_lng").value);
    marker.setPosition(initLocation);
    map.setCenter(initLocation);
    }
    
  //GEOCODER
  geocoder = new google.maps.Geocoder();

}
		
$(document).ready(function() { 
         
  initialize();
   // Define north-east and south-west points of Sweden
   var ne = new google.maps.LatLng(69.20, 25.00);
   var sw = new google.maps.LatLng(54.50, 10.50);
			  
  $(function() {
    $("#event_street").autocomplete({
      //This bit uses the geocoder to fetch address values
      source: function(request, response) {
        geocoder.geocode( {'address': request.term + ', Sverige', 'bounds':  new google.maps.LatLngBounds(sw, ne) }, function(results, status) {
          response($.map(results, function(item) {
            return {
              label:  item.formatted_address,
              value: item.formatted_address,
              latitude: item.geometry.location.lat(),
              longitude: item.geometry.location.lng()
            }
          }));
        })
      },
      //This bit is executed upon selection of an address
      select: function(event, ui) {
        $("#event_lat").val(ui.item.latitude);
        $("#event_lng").val(ui.item.longitude);
        var location = new google.maps.LatLng(ui.item.latitude, ui.item.longitude);
        marker.setPosition(location);
        map.setCenter(location);
        map.setZoom(15);
      }
    });
  });
	
  //Add listener to marker for reverse geocoding
  google.maps.event.addListener(marker, 'drag', function() {
    geocoder.geocode({'latLng': marker.getPosition()}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[0]) {
          $('#event_re_geocoded_street').val(results[0].formatted_address);
          $('#event_lat').val(marker.getPosition().lat());
          $('#event_lng').val(marker.getPosition().lng());
        }
      }
    });
  });
  
});