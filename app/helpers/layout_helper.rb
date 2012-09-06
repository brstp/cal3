# coding: utf-8
# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  
  def share_me 
    str = %(
            <div class='social_box' id='facebook'>
              <div class='fb-like' data-href=#{url_for(:only_path => false)} data-send='false' data-show-faces='true' data-width='230'></div>
            </div>
            <div class='social_box' id='twitter'>
              <a class='twitter-share-button' data-lang='sv' data-size='large' data-via='allom_se' href='https://twitter.com/share'>Tweeta</a>
            </div>
            <div class='social_box' id='plusone'>
              <div class='g-plusone' data-annotation='inline' data-href=#{url_for(:only_path => false)} data-size='tall' data-width='260'></div>
            </div>
            <div class='social_box' id='email'>
              #{link_to image_tag("email-button.png", :alt => "Tipsa en vän om det här evenemanget med ett mejl.", :title => "Tipsa en vän om det här evenemanget med ett mejl." ), ""} 
            </div>
    )
    raw str
  end

  def user_message organizer, user
    if false && (! organizer.users.include? user)  && (organizer.memberships.find_by_prospect_user_id(user.id))
      str = %(
                <div class = "user_message">
                    Du har ansökt om att bli administratör hos föreningen #{I18n.localize(organizer.memberships.find_by_prospect_user_id(user.id).created_at) }. Din ansökan kommer att behandlas av föreningens administratörer. 
                    #{button_to "Ångra ansökan om behörighet"}
                </div>
              )
      raw str
    end
  end
  


  def my_organizers user
    unless user.blank?
      str = ""
        str << %(
                <div class = "box my_organizers">
                  <span class="heading"> #{t 'organizers.show.my_organizers' }:</span>
                )
        unless user.organizers.blank?
          str << %(
                   <ul>
          )
          for organizer in user.organizers  
            str << %(
                      <li>#{link_to organizer.name,  organizer}</li>  
                    )
          end
          str << %(
                    </ul>
                  )
        else
           str << %(
                    <p>#{t('organizers.show.no_organizer')}</p>
                    )
        end
          str << %(
                    <p>#{t('organizers.show.do_apply')} #{t('organizers.show.organizers_using')}  #{t'app.or'} <strong>#{ link_to t('organizers.show.register_new'), new_organizer_path}</strong>.</p>  
                  )
        
        petition_organizers = user.petition_organizers
        unless petition_organizers.blank?
          str << %(
                  <p>
                    #{t 'organizers.show.you_have_applied'}:
                  </p>
                  <ul>
                  )
          
          for organizer in petition_organizers
            str << %(
                      <li>#{link_to organizer.name,  organizer}</li>  
                    )
          end
          str << %(
                    </ul>
                  )
        end
                  
        str << %(
                    </div><!-- /my_organizers -->
                  )
      raw str
    end
  end
  

  
  def facet_search
    str = ""
    unless params[:q].blank? && params[:stop].blank? && params[:category_facet_id].blank? && params[:organizer_id].blank? && params[:municipality_id].blank?
      str << %(#{link_to t('.reset_search') })
    else
      str << %(&nbsp;)
    end
    str << %(        
        <ul>
            )
    str << %(<li class = "facet-1">#{t'.when'}</li>)
    str << facet_when( @stop_facet_rows )
    str << %(<li class = "facet-1">#{t'.categories'}</li>)
    str << (facet_category( @category_facet_rows ))
    str << %(<li class = "facet-1">#{t'.organizers'}</li>)
    str << facet_organizer( @organizer_facet_rows )
    str << %(<li class = "facet-1">#{t'.municipalities'}</li>)
    str << facet_municipality( @municipality_facet_rows )
    str << %(
            </ul>
            )
      
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
                                            :stop => row.value,
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => params[:municipality_id]
                                          ) ) }
                </li>
              )
      end

      unless params[:stop] == "past"
      str << %(
                <li class = "facet-2">
                  
                  #{link_to( t('when_facet.past').capitalize, 
                              events_path(  :q => params[:q], 
                                            :stop => :past,
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => params[:municipality_id]
                                          ) ) }
                  
                </li>
              )
      end
      
      unless params[:stop] != "past"
      str << %(
                <li class = "facet-2">
                  <strong>
                  #{link_to( t('when_facet.future').capitalize, 
                              events_path(  :q => params[:q], 
                                            :stop => nil,
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
        unless row.instance.blank?
          str << %(
                    <li>
                      #{link_to( row.instance.and_mum.capitalize + " (" + row.count.to_s +  ")", 
                                  events_path(  :q => params[:q], 
                                                :stop => params[:stop],
                                                :category_facet_id => row.instance,
                                                :organizer_id => params[:organizer_id],
                                                :municipality_id => params[:municipality_id]
                                              ) ) }
                    </li>
                  )
        end
      end
      unless params[:category_facet_id].blank?
      str << %(
                <li class = "facet-2">
                  <strong>
                  #{link_to( t('.show_all_facets'), 
                              events_path(  :q => params[:q], 
                                            :stop => params[:stop],
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
                                            :stop => params[:stop],
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => row.instance.id,
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
                                            :stop => params[:stop],
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
                                            :stop => params[:stop],
                                            :category_facet_id => params[:category_facet_id],
                                            :organizer_id => params[:organizer_id],
                                            :municipality_id => row.instance.id
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
                                            :stop => params[:stop],
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
  
  

  


  
  def municipality_facts municipality
    unless municipality.facts.blank?
      str = %(
          <div id="municipality_facts" class="box">
            #{municipality.facts}
            <p class = "wikipedia-source"> 
            Faktatext från #{link_to("Wikipedia", municipality.wikipedia_page, :rel => :nofollow)}. Senast hämtad: #{I18n.localize(municipality.facts_last_updated, :format => :default)}
            Rättigheter enligt #{link_to("CC BY-SA 3.0", "http://creativecommons.org/licenses/by-sa/3.0/deed.sv", :rel => :nofollow)}. Faktabilder från #{link_to "Wikimedia", "http://commons.wikimedia.org/wiki/Main_Page", :rel => :nofollow}. Rättigheter: #{link_to("CC BY-SA 2.5", "http://creativecommons.org/licenses/by-sa/2.5/deed.sv", :rel => :nofollow)}. </p>
            </div>
          )
      raw str
    end
  end




  def map_marker(event)
   str = %(
  function initialize() {
    var myLatLng = new google.maps.LatLng( #{event.lat}, #{event.lng});
    var myOptions = {
                zoom: 10,
                center: myLatLng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    var map = new google.maps.Map(document.getElementById("map_view"), myOptions);

    var contentString = '<div class="map_info_window"><h1>#{event.subject}</h1><p>#{event.intro}</p><p>#{event.duration.capitalize}. Arrangeras av #{event.organizer.name} i ämneskategorin #{event.category.name}.</p></div>';
 
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });

    var marker = new google.maps.Marker({
        position: myLatLng,
        map: map,
        title: '#{event.subject}  #{event.duration.capitalize}',
        draggable: false
    });
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map,marker);
    });

    var weatherLayer = new google.maps.weather.WeatherLayer({
    });
    weatherLayer.setMap(map);

  }
  google.maps.event.addDomListener(window, 'load', initialize);
        )
    raw str
  end
  

  def map_markers(event)
   str = %(
  function initialize() {
    var myLatLng = new google.maps.LatLng( #{event.lat}, #{event.lng});
    var myOptions = {
                zoom: 10,
                center: myLatLng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    var map = new google.maps.Map(document.getElementById("map_view"), myOptions);

    var contentString = '<div class="map_info_window"><h1>#{event.subject}</h1><p>#{event.intro}</p><p>#{event.duration.capitalize}. Arrangeras av #{event.organizer.name} i ämneskategorin #{event.category.name}.</p></div>';
 
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });

    var marker = new google.maps.Marker({
        position: myLatLng,
        map: map,
        title: '#{event.subject}  #{event.duration.capitalize}',
        draggable: false
    });
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map,marker);
    });


  }
  google.maps.event.addDomListener(window, 'load', initialize);
        )
    raw str
  end



  def upcoming_and_past_events organizer, max_no = 99999
  
    str = ""
    if organizer.upcoming_events.count > 0
      str << %(
                #{mini_calendar organizer.upcoming_events(max_no) , events_url }
              )
        
      if organizer.number_of_upcoming_events > max_no
        str << %(
                  #{link_to(t('app.there_are') + ' ' + organizer.number_of_upcoming_events.to_s + ' ' + t('app.events_in_total'), events_url(:organizer_id => organizer.id) )}
                )
      end
    end
    
    if organizer.past_events.count > 0
      str << %( 
                #{mini_calendar organizer.past_events(max_no) , events_url, t(".past_events") }  
              )
    end
            
    raw str
  end 
  
 
  def mini_calendar events = nil, more_events = events_url, caption = t('app.planned_events')


    
    cal = ""
    cal << %(
            <table class = "tiny-calendar">
              <caption>#{caption}</caption>
            )

    for event in events
      cal << %(
              <tr class = "#{cycle("odd", "even")}">
                <td>#{link_to( event.subject, event, :title => t('app.arranged_by') + ' ' + event.organizer.name + ' ' + t('app.in_municipality') + ' ' + event.municipality.name + '. ' + event.try( :intro))}</td>
                <td><abbr class="day" title="#{l(event.start_datetime, :format => :machine) }">
                      #{ l(event.start_datetime, :format => :mini) }
                    </abbr></td>
              </tr>
            )
    end
    reset_cycle
    cal << %(
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
  
  def timestamp
    str = ""
    file = File.open(File.expand_path('../../../.git/', __FILE__))
    file.each do |line|
      str << line
    end
    file.close
    str
  end
  
  
  def aside_calendar organizer
    events = organizer.upcoming_events
    str = ""
    unless events.blank?
      str << %(
                <table class='mini_calendar'>
                <caption>
                  #{organizer.s} kommande evenemang
                </caption>
                <tbody>
            )
      for event in events      
        str << %(
                    <tr itemscope itemtype="http://schema.org/Event">
                      <td>
                        <a class='inline_div' href='#{event_path event}' title='#{event.intro}'>
                          <div class='calendar_day'>
                            <div class='weekday'>#{l(event.start_datetime, :format => :abbr_day_of_week)}</div>
                            <div class='day_of_month'>#{l(event.start_datetime, :format => :day_of_month)}</div>
                            <div class='month'>#{l(event.start_datetime, :format => :abbr_month_of_year)}</div>
                          </div>
                        </a>
                      </td>
                      <td>
                        <a href='#{event_path event}' title='#{event.intro}' itemprop='url'>Kl #{l(event.start_datetime, :format => :time)}: <span itemprop="name">#{event.subject}</span> (#{event.category.name}). #{event.municipality_short}.</a>
                        <meta itemprop="startDate" content="#{l(event.start_datetime, :format => :machine)}">
                        <meta itemprop="description" content="#{event.intro}}">
                        <span itemprop="address" itemscope itemtype="http://schema.org/PostalAddress">
                          <meta itemprop="addressLocality" content="#{event.location}}">

                        </span>
                      </td>
                    </tr>
                )
      end 
      str << %(
                </table>
                <p class = "event_type">#{link_to "#{organizer.s} alla kommande evenemang (#{organizer.number_of_upcoming_events})", events_path(:organizer_id => organizer.id) }</p>
              )
    else
      str << %(Just nu har #{organizer.name} inte några evenemang inplanerade.)
    end
    unless organizer.past_events.blank?
      str << %(
              <p class = "event_type">#{link_to "#{organizer.s} alla tidigare evenemang (#{organizer.number_of_past_events})", events_path(:organizer_id => organizer.id, :stop => :past) }</p>
              )
    end  
    raw str
  end # /aside_calendars
  
end # module LayoutHelper
