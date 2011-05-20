# encoding: UTF-8
module EventsHelper


  def organizer_facts organizer
    str =%(
          <div id="municipality_facts" class="box">
          <span class="heading">#{t '.organizer_facts'}:</span>
          #{image_tag organizer.logotype.url(:small)}
          <h4>#{link_to(organizer.name, organizer)}</h4>
          <p>
          #{organizer.intro}
          #{mini_calendar organizer.upcoming_events}
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
