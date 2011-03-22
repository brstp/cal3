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
  
  def select_category_tree selected_category = nil
    raw %(
    <li class="radio required" id="event_category_input">
    <fieldset>
    <legend class="label">
    <label>#{t('formtastic.labels.event.category')}</label>
    </legend>
    <ol class = "category-level-0">
    #{Category.all.first.root.climb selected_category}
    </ol>
    </fieldset>
    <p class="inline-hints">#{t('formtastic.hints.event.category')}</p></li>
        )
  end
  
  def facet_search
    str = ""
    
    str << %(   
        #{link_to t('.reset_search') }
        <ul>
            )
    str << %(<li class = "facet-1">#{t'.when'}</li>)
    str << facet_when( @start_facet_rows )
    str << %(<li class = "facet-1">#{t'.categories'}</li>)
    str << (facet_category( @category_facet_rows ))
    str << %(<li class = "facet-1">#{t'.organizers'}</li>)
    str << facet_organizer( @organizer_facet_rows )
    str << %(<li class = "facet-1">#{t'.municipalities'}</li>)
    str << facet_municipality( @municipality_facet_rows )
    str << %(
            </ul>
          </div>)
      
    raw str
  
  end

  
  def facet_when facet_rows 
    str = ""
      unless facet_rows.blank? 
      str << %(
            <li class = "facet-2">
              <ul>
              )
      for row in facet_rows 
      str << %(
                <li>
                  #{link_to( t('when_facet.' + row.value.to_s).capitalize + " (" + row.count.to_s +  ")", 
                              events_path(  :q => params[:q], 
                                            :start => row.value,
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => params[:municipality_id]
                                          ) ) }
                </li>
              )
      end
      unless params[:start].blank?
      str << %(
                <li class = "facet-2">
                  <strong>
                  #{link_to( t('.show_all_facets'), 
                              events_path(  :q => params[:q], 
                                            :start => nil,
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => params[:municipality_id]
                                          ) ) }
                  </strong>                        
                </li>
              )
      end
      str << %(
              </ul>
            </li>
              )
    end
    raw str
  end
  
  
  def facet_category facet_rows 
    str = ""
      unless facet_rows.blank? 
      str << %(
            <li class = "facet-2">
              <ul>
              )
      for row in facet_rows 

      str << %(
                <li>
                  #{link_to( row.instance.and_mum.capitalize + " (" + row.count.to_s +  ")", 
                              events_path(  :q => params[:q], 
                                            :start => params[:start],
                                            :category_facet_id => row.instance,
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => params[:municipality_id]
                                          ) ) }
                </li>
              )
      end
      unless params[:category_facet_id].blank?
      str << %(
                <li class = "facet-2">
                  <strong>
                  #{link_to( t('.show_all_facets'), 
                              events_path(  :q => params[:q], 
                                            :start => params[:start],
                                            :category_facet_id => nil,
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => params[:municipality_id]
                                          ) ) }
                  </strong>                        
                </li>
              )
      end
      str << %(
              </ul>
            </li>
              )
    end
    raw str
  end
  
  def facet_organizer facet_rows 
    str = ""
      unless facet_rows.blank? 
      str << %(
            <li class = "facet-2">
              <ul>
              )
      for row in facet_rows 
      str << %(
                <li>
                  #{link_to( row.instance.to_s + " (" + row.count.to_s +  ")", 
                              events_path(  :q => params[:q], 
                                            :start => params[:start],
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => row.instance,
                                            :municipality_id => params[:municipality_id]
                                          ) ) }
                </li>
              )
      end
      unless params[:organizer_id].blank?
      str << %(
                <li class = "facet-2">
                  <strong>
                  #{link_to( t('.show_all_facets'), 
                              events_path(  :q => params[:q], 
                                            :start => params[:start],
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => nil,
                                            :municipality_id => params[:municipality_id]
                                          ) ) }
                  </strong>                        
                </li>
              )
      end
      str << %(
              </ul>
            </li>
              )
    end
    raw str
  end
  
  def facet_municipality facet_rows 
    str = ""
      unless facet_rows.blank? 
      str << %(
            <li class = "facet-2">
              <ul>
              )
      for row in facet_rows 
      str << %(
                <li>
                  #{link_to( row.instance.to_s + " (" + row.count.to_s +  ")", 
                              events_path(  :q => params[:q], 
                                            :start => params[:start],
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => row.instance
                                          ) ) }
                </li>
              )
      end
      unless params[:municipality_id].blank?
      str << %(
                <li class = "facet-2">
                  <strong>
                  #{link_to( t('.show_all_facets'), 
                              events_path(  :q => params[:q], 
                                            :start => params[:start],
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => nil
                                          ) ) }
                  </strong>                        
                </li>
              )
      end
      str << %(
              </ul>
            </li>
              )
    end
    raw str
  end
  
  
  def page_counter counter
    str = %(
            <div class = "box">
            <span class="heading">#{t('.page_viewed')}:</span>
            <span class = "counter">#{"%06.0f" % counter }</span>
            </div> 
          )

    raw str
  end
  
  def facebook_like(page_url, ref="default")
    str = %(
    <iframe src="http://www.facebook.com/plugins/like.php?href=#{page_url}&amp;layout=standard&amp;show_faces=false&amp;width=450&amp;action=recommend&amp;colorscheme=light&amp;height=35&amp;locale=sv_SE&amp;ref=#{ref}" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:450px; height:35px;" allowTransparency="true"></iframe>
    )
    
    raw str
  end
  
  def open_graph_properties title="", img="", url=""
    #TODO FB Admin in settings
    #TODO img per event (or generic img for the calendar)
    #     
    str = %(
    <meta property="og:title" content="#{title}" />
    <meta property="og:type" content="activity" />
    <meta property="og:url" content="#{url}" />
    <meta property="og:site_name" content="#{t('app.site_name')}" />
    <meta property="fb:admins" content="1083707575" /> 
    )
    unless img.blank?
      str << %(<meta property="og:image" content="#{img}" />)
    end
    content_for(:head) {
    raw str 
    }

  end
  
  def municipality_facts municipality
    unless municipality.facts.blank?
      str = %(
          <div id="municipality_facts" class="box">
           <span class="heading">Snabbfakta om #{municipality.name}</span>
            #{municipality.facts}
            <p class = "wikipedia-source"> 
            Faktatext från #{link_to("Wikipedia", municipality.wikipedia_page, :rel => :nofollow)}.
            Rättigheter enligt #{link_to("CC BY-SA 3.0", "http://creativecommons.org/licenses/by-sa/3.0/deed.sv", :rel => :nofollow)}. Faktabilder från #{link_to "Wikimedia", "http://commons.wikimedia.org/wiki/Main_Page", :rel => :nofollow}. Rättigheter: #{link_to("CC BY-SA 2.5", "http://creativecommons.org/licenses/by-sa/2.5/deed.sv", :rel => :nofollow)}. Senast hämtad: #{I18n.localize(municipality.facts_last_updated, :format => :default)}</p>
            </div>
          )
      raw str
    end
  end
  
  def organizer_facts organizer
    str =%(
          <div id="municipality_facts" class="box">
          <span class="heading">Fakta om arrangören: </span>
          #{image_tag organizer.logotype.url(:small)}
          <h4>#{link_to(organizer.name, organizer)}</h4>
          <p>
          #{organizer.intro}
          #{mini_calendar organizer.events.order("start_datetime ASC")}
          </div>
          )
    raw str
  end
  
  def map_marker(event)
   str = %(
        <script type="text/javascript">

        function initialize() {
          var latLng = new google.maps.LatLng( #{event.lat}, #{event.lng});
          var map = new google.maps.Map(document.getElementById('mapCanvas'), {
            zoom: 10,
            center: latLng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
          });
          var marker = new google.maps.Marker({
            position: latLng,
            title: '#{event.subject}  #{event.duration.capitalize}',
            map: map,
            draggable: false
          });
          
          updateMarkerPosition(latLng);
}

google.maps.event.addDomListener(window, 'load', initialize);
</script>)
    raw str
  end

 def draggable_map_marker(event)
   str = %(
          <script type="text/javascript">
          var geocoder = new google.maps.Geocoder();

          function geocodePosition(pos) {
            geocoder.geocode({
              latLng: pos
            }, function(responses) {
              if (responses && responses.length > 0) {
                updateMarkerAddress(responses[0].formatted_address);
              } else {
                updateMarkerAddress('Cannot determine address at this location.');
              }
            });
          }



          function updateMarkerPosition(latLng) {
            document.getElementById('event_lat').value = latLng.lat();
            document.getElementById('event_lng').value = latLng.lng();
          }

          function updateMarkerAddress(str) {
            document.getElementById('address').innerHTML = str;
          }

          function initialize() {
            var latLng = new google.maps.LatLng( #{event.lat}, #{event.lng});
            var map = new google.maps.Map(document.getElementById('mapCanvas'), {
              zoom: 10,
              center: latLng,
              mapTypeId: google.maps.MapTypeId.ROADMAP
            });
            var marker = new google.maps.Marker({
              position: latLng,
              title: '#{t('map.drag_me')}',
              map: map,
              draggable: true
            });
            
            // Update current position info.
            updateMarkerPosition(latLng);
            geocodePosition(latLng);
            
            
            google.maps.event.addListener(marker, 'drag', function() {
              updateMarkerPosition(marker.getPosition());
            });
            
            google.maps.event.addListener(marker, 'dragend', function() {
              geocodePosition(marker.getPosition());
            });
          }

          // Onload handler to fire off the app.
          google.maps.event.addDomListener(window, 'load', initialize);
          </script>
             )
   raw str
  end
  
  
  def arranged_by event
    raw ( t('app.arranged_by') + ' ' + link_to( (event.organizer.name+ ' (' + event.organizer.number_of_upcoming_events.to_s + ')'), event.organizer, :title => event.organizer.intro) ) 
  end
  
  def arranged_in event
    raw ( t('app.in_municipality') + ' ' + link_to(  (event.municipality.name + ' (' + event.municipality.number_of_upcoming_events.to_s + ')'), event.municipality ))
  end
  
  def in_category event
    category = event.category
    str = ""
    while category.depth > 0
      str = (link_to category.name + ' (' + category.number_of_upcoming_events.to_s + ')', (events_path :category_facet_id => category.id)) + " > " + str
      category = category.parent
    end
    str = (t '.category') + ': ' + str
    str = str.to(str.length - 7)
    raw str
  end

 
  def mini_calendar events = nil, more_events = events_url, max_no = 10
  #TODO time limits and no of events in initializer (and align)
    if events.nil?
      events = Event.where("stop_datetime >= ? AND start_datetime <= ?", 
                  Time.now.beginning_of_day, Time.now.end_of_day + 12.months ).
                  order('start_datetime ASC')
    end
    many_events = ""
    if events.count > max_no
      many_events = link_to(t('app.there_are') + ' ' + events.count.to_s + ' ' + t('app.events_in_total'), more_events) 
    end
    
    cal = ""
    cal << %(
            <table class = "tiny-calendar">
              <caption>#{t('app.planned_events')}</caption>
            )
    
    for event in events.limit max_no 
    cal << %(
              <tr class = "#{cycle("odd", "even")}">
                <td>#{link_to( event.subject, event, :title => t('app.arranged_by') + ' ' + event.organizer.name + ' ' + t('app.in_municipality') + ' ' + event.municipality.name + '. ' + event.try( :intro))}</td>
                <td><abbr class="day" title="#{l(event.start_datetime, :format => :machine) }">
                      #{ l(event.start_datetime, :format => :mini) }
                    </abbr></td>
              </tr>
            )
    end
   
    cal << %(
            <tr class = "#{cycle("odd", "even")}">
            <td colspan = "2">#{many_events}&nbsp;</td></tr>
            </table>
            )
    raw cal
  end
  
  def calendar events = nil
    #TODO time period in initialize
    #TODO limit in initializer
    cal = ""
    if events.nil?
    events = Event.where("stop_datetime >= ? AND start_datetime <= ?", 
                Time.now.beginning_of_day, Time.now.end_of_day + 2.months ).
                order('start_datetime ASC').limit 200 
    end     

    current_month = events.first.start_datetime.beginning_of_month
    current_day = events.first.start_datetime.beginning_of_day
    
    cal << %(
          <table class="calendar">
            <caption>#{l(events.first.start_datetime, :format => :month_and_year).capitalize}</caption>
            )
    
    cal <<  %(
            <tr>
              <th class="day_box">
                <span class="day_of_month">
                  <span class="#{l(events.first.start_datetime, :format => :day_of_week).gsub("ö", "o").gsub("å", "a")}">
                    <abbr class="day" title="#{l(events.first.start_datetime, :format => :date) }">
                      #{ l(events.first.start_datetime, :format => :day_of_month) }
                    </abbr>
                  </span>
                </span>
                <br />
                <span class="day_of_week">
                 #{l(events.first.start_datetime, :format => :day_of_week)}
                </span>
              </th>
              <td>
                <ol class="events_with_time">
              )
    
    for event in events
      cal << %(
        <!-- event.start_datetime.beginning_of_day: #{event.start_datetime.beginning_of_day.to_s} -->
        <!-- current_day: #{current_day} -->
              )
              
      if event.start_datetime.beginning_of_day == current_day
        cal << %(
                  <li class="event">
                    #{ link_to raw("<strong>" + event.subject + '</strong> ' + ' (' + event.category.try( :name) + ') ' + content_tag(:abbr,  l(event.start_datetime, :format => :clock), :title => "#{l(event.start_datetime, :format => :machine)}") + ', ' + event.municipality_short ) , event, :title => t('app.organizer') + ": " + event.organizer.name + ". " + t('app.summary') +": " + event.intro } 
                  </li>
              )
      else  
        cal << %(
                </ol>
              </td>
            </tr>)
       if event.start_datetime.beginning_of_month > current_month.beginning_of_month
          cal << %(</table>)
          cal << %(
                <table class="calendar">
                  <caption>#{l(event.start_datetime, :format => :month_and_year).capitalize}</caption>
                  )                   
        end 
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
        cal << %(
                  <li class="event">
                    #{ link_to raw("<strong>" + event.subject + '</strong> ' + ' (' + event.category.try( :name) + ') ' + content_tag(:abbr,  l(event.start_datetime, :format => :clock), :title => "#{l(event.start_datetime, :format => :machine)}") + ', ' + event.municipality_short ) , event, :title => t('app.organizer') + ": " + event.organizer.name + ". " + t('app.summary') +": " + event.intro } 
                  </li>
              ) 
      end
      current_day = event.start_datetime.beginning_of_day    
      current_month = event.start_datetime.beginning_of_month
    end 
    cal << %(
                </ol>
              </td>
            </tr>
            )
    cal << %(</table>)

    raw cal
  end #def calendar
  
end # module LayoutHelper
