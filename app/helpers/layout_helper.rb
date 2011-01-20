# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  # def title(page_title, show_title = true)
    # content_for(:title) { h(page_title.to_s) }
    # @show_title = show_title
  # end

  # def show_title?
    # @show_title
  # end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def map_marker(lat, lng)
   str = raw '<script type="text/javascript">'
   str += raw "$(document).ready(function() { $('#map_canvas').googleMaps({ latitude: #{lat}, longitude: #{lng}, depth: 10, markers: { latitude: #{lat}, longitude: #{lng}, draggable:false } }); });"
   str += raw '</script>' 
   str
  end

#TODO remove or rewrite. Not used  
 def map_marker_draggable(lat, lng)
   str = raw '<script type="text/javascript">'
   str += raw "$(document).ready(function() { $('#map_canvas').googleMaps({ latitude: #{lat}, longitude: #{lng}, depth: 10, markers: { latitude: #{lat}, longitude: #{lng}, draggable: true } }); });"
   str += raw '</script>' 
   str
  end
  
  
  def arranged_by event
    raw (t('app.arranged_by') + ': ' + link_to( (event.organizer.name+ ' (' + event.organizer.number_of_upcoming_events.to_s + ')'), event.organizer) ) 
  end
  
  def arranged_in event
    raw (t('app.in_municipality') + ' ' + link_to( (event.municipality.name + ' (' + event.municipality.number_of_upcoming_events.to_s + ')'), event.municipality ))
  end
  
end
