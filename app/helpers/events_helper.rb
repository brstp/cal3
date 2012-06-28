# encoding: UTF-8
module EventsHelper

  def related_events event, max_no = 9999
    municipality = event.municipality
    category = event.category

    str = ""
    
    if municipality.upcoming_events.count > 0
      str <<  %( 
                  #{mini_calendar municipality.upcoming_events(max_no), events_url, t('.events_nearby') }
                )
    end
       
    if category.upcoming_events.count > 0
      str <<  %(
                #{mini_calendar category.upcoming_events(max_no), events_url, t('.events_in_same_category') }
              )
    end
    
    unless str.blank?
      raw   %(
                <div id="related_events" class="box">
                  <span class="heading">#{t '.related_events'}:</span>
                  #{str}
                </div>
              )
    end
 
  end
  
  def query_to_string default_str = t('app.site_name')
    str =""
    unless  ( params[:q].blank? && 
              params[:category_facet_id].blank? && 
              params[:municipality_id].blank? && 
              params[:organizer_id].blank? )
            
      unless params[:organizer_id].to_i == 0 
        str = str + Organizer.find(params[:organizer_id].to_i).s + " "
      end
      str = str + " " + params[:q].to_s + " "
      unless params[:category_facet_id].to_i == 0
        str = str + Category.find(params[:category_facet_id].to_i).name + " "
      end
      if str.blank? 
        str = str + " " + t('app.events').titleize + " "
      else
        str = str + " " + t('app.events') + " "
      end
      unless params[:municipality_id].to_i == 0
        str = str + " i " + Municipality.find(params[:municipality_id].to_i).short_name
      end
    else
      str = default_str
    end
    str = str.squish
    str
  end

  def organizer_facts organizer, max_no = 9999
  
  str =%(
          <div id="organizer_facts" class="box">
          <span class="heading">#{t '.organizer_facts'}:</span>
        )
  unless organizer.logotype.blank?
    str << %(
              #{link_to((image_tag  organizer.logotype.url(:small), :alt => organizer.name + "s logotyp", :title => organizer.intro), organizer, :title => organizer.name )}
            )
  end
    
  str << %(
          <h4>#{link_to(organizer.name, organizer)}</h4>
          <p>
          #{organizer.intro}
          </p>
          )
          
    str << %( #{upcoming_and_past_events organizer} 
    
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

  def event_footer 
    str = %(Evenemangsannonsen skapad #{l @event.created_at })
    if current_user
      if (current_user.authorized? @event) || current_user.is_admin?
        str << %( #{@event.created_by}.)
        unless @event.last_googleboted.blank?
          str << %( Senast besökt #{l(@event.last_googleboted)} av Google sökmotorrobot.)
        end
      end
    end
    
    unless @event.created_at == @event.updated_at || @event.updated_by_user_id.nil?
      str << %( Uppdaterad #{l @event.updated_at})
      if current_user
        if (current_user.authorized? @event) || current_user.is_admin?
          str << %( #{@event.updated_by})
        end
      end
      str << %(. )
    end
     
    str << %( Annonsens texter & bilder är licensierade av arrangören under Creative Commons Erkännande-DelaLika 2.5 Sverige Licens, CC (BY-SA).)
    str
  end
  
  def event_meta
    unless @event.image1.blank?
      logo =  @event.image1.url(:medium)
    else
      logo = request.protocol + request.host_with_port + image_path("evenemang-allom-evenemangskalendern.png") 
    end  
    
    set_meta_tags( 
      :title => @event.subject,
      :description => "#{@event.intro}. Arrangör: #{@event.organizer.name}.",
      :canonical => "http://allom.se#{event_path(@event)}",
      :open_graph => {
        :title => @event.subject,
        :type  => :activity,
        :url   => "http://allom.se#{event_path(@event)}" ,
        :image => logo,
        :site_name => "Allom - evenemangskalendern",
        }
      )
      
    content_for :head do  
      raw ("<link rel=\"image_src\" href=\"#{logo}\" />")
    end
  end

end
  
