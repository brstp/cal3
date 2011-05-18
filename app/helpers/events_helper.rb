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
  
end
