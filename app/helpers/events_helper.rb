# encoding: UTF-8
module EventsHelper

  
  def query_to_string default_str = t('app.site_name')
    str =""
    unless  ( params[:q].blank? && 
              params[:c1_id].blank? && 
              params[:c2_id].blank? && 
              params[:c3_id].blank? && 
              params[:municipality_id].blank? && 
              params[:organizer_id].blank? )
            
      unless params[:organizer_id].to_i == 0 
        str = str + Organizer.find(params[:organizer_id].to_i).s + " "
      end
      str = str + " " + params[:q].to_s + " "
      
      str = str + Category.find(params[:c1_id].to_i).name + " " unless params[:c1_id].to_i == 0
      str = str + Category.find(params[:c2_id].to_i).name + " " unless params[:c2_id].to_i == 0
      str = str + Category.find(params[:c3_id].to_i).name + " " unless params[:c3_id].to_i == 0
      
      if str.blank? 
        str = str + " " + t('app.events').titleize + " "
      else
        str = str + " " + t('app.events') + " "
      end
  
      str = str + " i " + Municipality.find(params[:municipality_id].to_i).short_name unless params[:municipality_id].to_i == 0
      
    else
      str = default_str
    end
    str = str.squish
    str
  end


  def select_category_tree selected_category = nil, error_message = nil
    
    
    raw %(
    <li class="radio required" id="event_category_input">
    
    <fieldset>
    <legend class="label">
    <label>#{ Event.human_attribute_name('category') }*</label>
    </legend>
    <p class="inline-hints">#{t('formtastic.hints.event.category')}</p>
    #{"<p class='inline-errors'>#{error_message}</p>" unless error_message.blank?}
    <ol class = "category-level-0" >
    #{Category.all.first.climb selected_category}
    </ol>
    </fieldset>
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
          str << %( Senast besökt #{l(@event.last_googleboted)} av Googles sökmotorrobot.)
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
     
    str
  end
  
  def event_meta
    unless @event.image1_file_name.blank?
      icon = image_path(@event.image1.url(:medium))
    else
      icon = "http://allom.se" + image_path("evenemang-allom-evenemangskalendern.png") 
    end  
    title = @event.subject
    title = title + " | " + l( @event.start_datetime, :format => :mini) if @event.start_date == @event.stop_date
    set_meta_tags( 
      :title => title,
      :description => "#{@event.intro.blank? ? @event.description.truncate(100) : @event.intro}. Arrangör: #{@event.organizer.name}.",
      :canonical => "http://allom.se" + event_path(@event).split(".")[0],
      :open_graph => {
        :title => @event.subject,
        :type  => :activity,
        :description => "#{@event.intro.blank? ? @event.description.truncate(100) : @event.intro}. Arrangör: #{@event.organizer.name}.",
        :url   => "http://allom.se" + event_path(@event) ,
        :image => icon,
        :site_name => "Allom - evenemangskalendern",
        }
      )
      
    content_for :head do  
      raw ("<link rel=\"image_src\" href=\"#{icon}\"/>")
    end
  end
  


  
  def admin_event  
    if current_user
      if (current_user.authorized? @event.organizer ) || current_user.is_admin?
        str = ""
        str << %(
                  <div class = "user_message">
                    <h2>Administration av evenemangsannonsen</h2>
                )

        if current_user.is_admin?
          str << %(
                    <p>Du är systemadministratör.</p>
                  )
        end
        
        if (current_user.authorized? @event.organizer )
           str << %(
                      <p>Du är administratör för #{@event.organizer.name}.</p>
                    )
        end
        str << %(
                      <p>
                      #{link_to( "Lägg in en ny evenemenangsannons", new_event_path(:organizer_id => @event.organizer.id))}
                      </p>
                      <p>
                )
        str <<  button_to( "Ändra evenemangsannonsen", edit_event_path(@event), :method => :get ) 
        str << %(</p><p>)
        str << button_to( "Ta bort evenemangsannonsen", @event, :confirm => "Är du säker på att du vill radera evenemangsannonsen \"#{@event.subject}\"? Det kommer inte att gå att återställa den. Du får gärna ha kvar annonser för evenemang som redan har varit.", :method => :delete )             

        str << %(
                  </p>
                  </div>
                )
        raw str
      end
    end
  end # /admin_event


  def page_counter counter
    str = %(
            <div class='counter'>
              <div class='counter_text1'>Sidan visad:</div>
              <span class='counter_number'>#{"%06.0f" % counter }</span>
              <div class='counter_text2'>gånger.</div>
            </div>
          )

    raw str
  end # /page_counter


end
  
