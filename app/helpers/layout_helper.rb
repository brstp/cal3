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
  
  def draw_map markers_json
    no_of_markers = JSON.parse(markers_json).count
    if no_of_markers > 1
      gmaps(:map_options => {:detect_location => false, :center_on_user => false, :auto_adjust => true}, "markers" => {"data" => markers_json, :options => { :do_clustering => true, randomize: true, :max_random_distance => 25 } })
    else
      if no_of_markers == 1
        gmaps(:map_options => {"auto_zoom" => false, "zoom" => 11, :detect_location => false, :center_on_user => false, :auto_adjust => true}, "markers" => {"data" => markers_json, :options => { :do_clustering => false } }) 
      else 
        gmaps(:map_options => {"auto_zoom" => false, "zoom" => 1, :detect_location => false, :center_on_user => false, :auto_adjust => true}, "markers" => {"data" => markers_json, :options => { :do_clustering => false } })
      end
    end
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
    )
    raw str
    
      # <div class='social_box' id='email'>
      #  #{link_to image_tag("email-button.png", :alt => "Tipsa en vän om det här evenemanget med ett mejl.", :title => "Tipsa en vän om det här evenemanget med ett mejl." ), ""} 
      # </div>
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
  


  
  def municipality_facts municipality
    unless municipality.facts.blank?
      str = %(
          <div id="municipality_facts" class="box">
            <blockquote cite=\""#{municipality.wikipedia_page}"\" lang="sv_SE" class="wikipedia">
            #{municipality.facts}
            </blockquote>
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

  
  
  def timestamp
    str = ""
    file = File.open(File.expand_path('../../../.git/', __FILE__))
    file.each do |line|
      str << line
    end
    file.close
    str
  end
  
  def mini_calendar events, max_no = 5
    
    str = %(
      <table class = "mini_calendar">
        <tbody>
        )
    for event in events.first max_no
      str << %(
          <tr>
            <td class = "sheet">
              <a href = "#{event_path event}" title = "#{event.subject}. #{event.intro}">
                <div class = "calendar_day">
                  <div class = "weekday">
                    #{l(event.start_datetime, :format => :abbr_day_of_week)}
                  </div>
                  <div class = "day_of_month">
                    #{l(event.start_datetime, :format => :day_of_month)}
                  </div>
                  <div class = "month">
                    #{l(event.start_datetime, :format => :abbr_month_of_year)}
                  </div>
                </div>
              </a>
            </td>
            <td class = "event">
              <a href = "#{event_path(event)}" title = "#{event.intro}">
                Kl #{l(event.start_datetime, :format => :time)}: #{event.subject} (#{event.category.name}). #{event.municipality_short}. #{event.organizer.name}.
              </a>
            </td>
          </tr>
      )
    end
    str << %(
        </tbody>
      </table>
      )

    raw str
    
  end # /mini_calendar
    

  
end # module LayoutHelper
