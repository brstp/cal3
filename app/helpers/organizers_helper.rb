# encoding: UTF-8
module OrganizersHelper


  def promote_organizer organizer
    str = %(
              <div class = "box" id = "promote_organizer">
              <span class="heading">#{ t('.promote') }<br /> #{organizer.name}:</span>
            )
            if organizer.future_events?
              str << %(
                      <p>
                        #{link_to(t('.download_ics1') + ' ' + organizer.s + ' ' + t('.download_ics2'), organizer_url(:only_path => false, :format => :ics ), :title => t('app.ics_file')) }
                      </p>
                      )
            end
            
            str << %(
                      <p>
                        #{ link_to t('.subscribe_rss') + ' ' + organizer.name, :format => :rss, :only_path => false }  
                        #{ link_to image_tag("rss_icon.gif", :alt => t('.rss_alt') + ' ' + organizer.name), :format => :rss, :only_path => false }
                        #{ link_to t('.whats_rss'), "http://sv.wikipedia.org/wiki/RSS-l%C3%A4sare", :rel => :nofollow }
                      </p>
                      <p>
                        #{ t('.share_as_iframe') }
                      </p>
                      #{ text_area_tag( "id", h('<iframe src="' + organizer_url(:format => :ihtml) + '"  frameborder="1" ></iframe>'), :class => :iframe_me, :readonly => true) }
                    </div> <!-- /promote_organizer -->
                    )
    raw str
  end


  def admin_message  
    if current_user
      if (@organizer.users.include? current_user) || current_user.is_admin? || (@organizer.petition_users.include? current_user)
        str = ""
        str << %(
                  <div class = "user_message">
                    <h2>Administration av #{@organizer.s} arrangörssida</h2>
                )

        if current_user.is_admin?
          str << %(
                    <p>Du är systemadministratör.</p>

                    #{ 
                      button_to(  
                        "Radera arrangörssidan", 
                        @organizer, 
                        :confirm => "Är du säker att du vill radera arrangörssidan för #{@organizer.name}? Det kommer inte gå att återskapa den. Alla arrangörens evenemangsannonser kommer också att raderas.", 
                        :method => :delete ) }
                  )
        end
        
        if @organizer.users.include? current_user
           str << %(
                      <p>Du är administratör för #{@organizer.name}.</p>
                    )
        end
        unless @organizer.petition_users.blank?
          str << %(
                    <p>#{link_to "Du har ansökningar att bli administratör att behandla", :anchor => :admin}</p>
                  )
        end
        str << %(
                    <p>
                      #{link_to "Lägg in ny evenemangsannons", new_event_path(:organizer_id => @organizer.id)}
                    </p>
                    #{ button_to(  "Ändra arrangörssidan",
                      edit_organizer_path(@organizer), 
                      :method => :get, 
                      :class => :organizer_user)}    

                    
                  )
        unless @organizer.petition_users.blank?
          str << %(
                    <h3>Användare som vill bli administratörer för #{@organizer.name}</h3>
                    <table class = "general">
                  )
          for petition in @organizer.petitions
            str << %(
                      <tr>
                        <td>#{ image_tag avatar_url(petition.user) }</td>
                        <td>#{   
                          if current_user.is_admin
                            link_to petition.user , petition.user 
                          else
                            petition.user 
                          end
                            }</td>
                        <td>#{ link_to"godkänn/avslå", edit_petition_path(petition) }</td>
                      </tr>
                    )            
          end
          
                  
          str << %(
                    </table>
                  )
        else
          str << %(
                    <p>Inga ansökningar att bli administratör just nu.</p>
                  )          
        end
        
        str << %(                    
                    <h3>Administratörer för #{@organizer.name}</h3>
                      <table class = "general"> 
                )  

      for user in @organizer.users
        str << %(
            <tr>
              <td>#{image_tag avatar_url(user)}<br /></td>
              <td>
              #{
                if current_user.is_admin
                  link_to user, user 
                else
                  user
                end
              }
              </td>
              <td>
                #{
                  unless user == current_user
                    button_to "Ta bort" ,
                    membership_path(Membership.find(:first, :conditions => ["organizer_id = ? and user_id = ?", @organizer.id, user.id])), 
                    :confirm => "Är du säker på att du vill ta bort administratörsskapet för #{user.name} från #{@organizer.name}? ", 
                    :method => :delete
                  end
                  }
              </td>
            </tr>
                )
      end 
      str << %(
                </table>
                <h3>Bjud in någon att bli administratör</h3>
                <p>Kopiera länken #{ link_to organizer_path( :only_path => false, :recruit => 1 ), organizer_path( :only_path => false, :recruit => 1 ) } och mejla till den som du vill dela ut behörighet till. Hen kan då göra en ansökan som du godkänner här på arrangörssidan.</p>

              )
  
        if @organizer.petition_users.include? current_user 
          str << %(
                    <p>
                      #{link_to( 
                        "Du har ansökt om att bli administratör för #{@organizer.name}.",
                        @organizer.petitions.find_by_user_id(current_user.id)
                        )}
                    </p>                  
                  )
        end
        str << %(
                  </div>
                )
        raw str
      end
    end
  end # /admin_message

  
  def organizer_meta
    
    unless @organizer.logotype.blank?
      organizer_logo =  @organizer.logotype.url(:medium)
    else
      organizer_logo = request.protocol + request.host_with_port + image_path("evenemang-allom-evenemangskalendern.png") 
    end  
    
    set_meta_tags( 
      :title => @organizer.name,
      :description => "Kolla in  #{@organizer.s} alla evenemang. Du kan också annonsera på Allom. #{@organizer.intro}",
      :canonical => "http://allom.se#{organizer_path(@organizer)}",
      :open_graph => {
        :title => @organizer.name,
        :type  => :activity,
        :url   => "http://allom.se#{organizer_path(@organizer)}" ,
        :image => organizer_logo,
        :site_name => "Allom - evenemangskalendern",
        }
      )
      
    content_for :head do  
      (raw "<link rel=\"image_src\" href=\"#{organizer_logo}\" />") + "\n" + auto_discovery_link_tag( :rss, organizer_url(:format => 'rss') , {:title => "#{@organizer.s} evenemang på Allom - evenemangskalendern."})
    end
       
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
                        <a href='#{event_path event}' title='#{event.intro}' itemprop='url'><span itemprop="name">#{event.subject}</span> #{l(event.start_datetime, :format => :time)}, #{event.municipality_short}</a>
                        <meta itemprop="startDate" content="#{l(event.start_datetime, :format => :machine)}">
                        <meta itemprop="description" content="#{event.intro}}">
                        <span itemprop="address" itemscope itemtype="http://schema.org/PostalAddress">
                          <meta itemprop="addressLocality" content="#{event.municipality}}">
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
  end
                
  def footer organizer
    
    str = %(Arrangörssidan skapad #{l organizer.created_at })
    if current_user
      if (current_user.authorized? organizer) || current_user.is_admin?
        str << %( #{organizer.created_by}.)
        unless organizer.last_googleboted.blank?
          str << %( Senast besökt #{l(@organizer.last_googleboted)} av Google sökmotorrobot.)
        end
      end
    end
    
    unless organizer.created_at == @organizer.updated_at || @organizer.updated_by_user_id.nil?
      str << %( Uppdaterad #{l organizer.updated_at})
      if current_user
        if (current_user.authorized? organizer) || current_user.is_admin?
          str << %( #{organizer.updated_by})
        end
      end
      str << %(. )
    end
     
    str << %( Sidans texter & bilder är licensierade av arrangören under Creative Commons Erkännande-DelaLika 2.5 Sverige Licens, CC (BY-SA).)
    str
  end
  
end
