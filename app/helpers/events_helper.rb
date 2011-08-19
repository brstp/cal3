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
  
end
  
