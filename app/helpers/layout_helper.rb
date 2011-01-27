# coding: utf-8
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
  
  
  def calendar
    #TODO period in initialize
    #TODO limit in initializer
    cal = ""
    
    events = Event.where("stop_datetime >= ? AND start_datetime <= ?", 
                Time.now.beginning_of_day, Time.now.end_of_day + 2.months ).
                order('start_datetime ASC').limit 200 
         
    cal << %(
          <table class="calendar">
            <caption>Evenemangskalender för #{l(events.first.start_datetime, :format => :month_and_year)}</caption>
            )
    current_month = events.first.start_datetime.beginning_of_month
    current_day = events.first.start_datetime.beginning_of_day - 1.day
    
    for event in events
      cal << %(<!--  debug -->)
      logger.info "%%%%%%%%%%%%%%%%%%%%%%%%current_day" + current_day.to_s
      logger.info "%%%%%%%%%%%%%%%%%%%%%%%%event" + event.start_datetime.beginning_of_day.to_s
      
      if event.start_datetime.beginning_of_month > current_month
        cal << %(</table>)
        cal << %(
              <table class="calendar">
                <caption>Evenemangskalender för #{l(event.start_datetime, :format => :month_and_year)}</caption>
                )   
                
        current_month = event.start_datetime.beginning_of_month
      end
      
      if event.start_datetime.beginning_of_day > current_day
      cal <<  %(
              <tr>
                <th class="day_box">
                  <span class="day_of_month">
                    <span class="#{l(event.start_datetime, :format => :day_of_week).gsub("ö", "o").gsub("å", "a")}">
                      <abbr class="day" title="#{l(event.start_datetime, :format => :date) }">
                        #{ l(event.start_datetime, :format => :day_of_month) }
                      </abbr>
                    </span>
                  </span>
                  <br />
                  <span class="day_of_week">
                   #{l(event.start_datetime, :format => :day_of_week)}
                  </span>
                </th>
                <td>
                  <ol class="events_with_time">
                )
      end

      cal << %(
              <li class="event">
              #{ link_to raw("<strong>" + event.subject + '</strong> ' + content_tag(:abbr,  l(event.start_datetime, :format => :clock), :title => "#{l(event.start_datetime, :format => :machine)}") + ', ' + event.municipality_short) , event, :title => t('app.organizer') + ": " + event.organizer.name + ". " + t('app.summary') +": " + event.intro }
              </li>)
      
      if event.start_datetime.beginning_of_day > current_day # and not another on same day...
        cal << %(</ol>
            </td>
          </tr>)
        current_day = event.start_datetime.beginning_of_day
      end  
     
    
    end 
    cal << %(</table>)

    raw cal
  end #def calendar
  
end # module LatoutHelper