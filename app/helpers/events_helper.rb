# encoding: UTF-8
module EventsHelper


  def organizer_facts organizer, max_no = 9999
    str =%(
          <div id="organizer_facts" class="box">
          <span class="heading">#{t '.organizer_facts'}:</span>
          #{link_to((image_tag  organizer.logotype.url(:small), :alt => organizer.name + "s logotyp", :title => organizer.intro), organizer, :title => "Allom - kalendern med allt som händer innan det är för sent." )}
          <h4>#{link_to(organizer.name, organizer)}</h4>
          <p>
          #{organizer.intro}
          </p>
          #{mini_calendar organizer.upcoming_events(max_no) , events_url }
          
          )
      
    if organizer.number_of_upcoming_events > max_no
      str << %(
                #{link_to(t('app.there_are') + ' ' + organizer.number_of_upcoming_events.to_s + ' ' + t('app.events_in_total'), events_url(:organizer_id => organizer.id) )}
              )
    end
    
    str << %(
          </div>
            )
    raw str
    
  end
  
  def select_category_tree selected_category = nil
    raw %(
    <li class="radio required" id="event_category_input">
    <fieldset>
    <legend class="label">
    <label>#{ Event.human_attribute_name('category') }*</label>
    </legend>
    <ol class = "category-level-0" >
    #{Category.all.first.climb selected_category}
    </ol>
    </fieldset>
    <p class="inline-hints">#{t('formtastic.hints.event.category')}</p></li>
        )
  end
  
  
   def duration event
    str = %(
                <abbr class="dtstart" title="#{I18n.localize(event.start_datetime, :format => :machine)}">
                  #{I18n.localize(event.start_datetime, :format => :longest)}
                </abbr>
                )
    unless  (event.start_datetime == event.stop_datetime)
      str << %(
                -
                <abbr class="dtend" title="#{I18n.localize(event.stop_datetime, :format => :machine)}">
                )
      if event.start_date != event.stop_date
        str << %( #{I18n.localize(event.stop_datetime, :format => :longest)} )
      else
        str << %( #{I18n.localize(event.stop_datetime, :format => :time)} )
      end
      str << %( </abbr>)
    end
    raw str
  end
  
  
  def lat_lng event
    str = %( <abbr class ="geo" title ="#{event.lat};#{event.lng}">)
    if event.lat >= 0
      str << %(N )
    else
      str << %(S )
    end
    str << %( #{event.lat_degrees_minute} )
    
    if event.lng >= 0
      str << %(O )
    else
      str << %(V )
    end
    str << %(#{event.lng_degrees_minute} </abbr>)
    
    raw str
  end
  
  
  def arranged_by event
  
    raw ( t('app.arranged_by') + ' <span class="organizer">' + link_to( ( event.organizer.name + ' (' + event.organizer.number_of_upcoming_events.to_s + ')'), event.organizer, :title => event.organizer.intro) + '</span>') 
  end
  
  def arranged_in event
    raw ( t('app.in_municipality') + ' ' + link_to(  (event.municipality.name + ' (' + event.municipality.number_of_upcoming_events.to_s + ')'), event.municipality ))
  end
  
  def in_category event
    exit if event.category.blank?
    category = event.category
    str = ""
    while category.depth > 0
      str = (link_to category.name + ' (' + category.number_of_upcoming_events.to_s + ')', (events_path :category_facet_id => category.id)) + " > " + str
      category = category.parent
    end
    str = (t '.category') + ' ' + str
    str = str.to(str.length - 7)
    raw( '<span class = "category">' + str + '</span>' )
  end

  
end
  
