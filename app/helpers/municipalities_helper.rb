module MunicipalitiesHelper
  
  
  def municipality_meta

    unless @municipality.escutcheon.blank?
      municipality_logo =  @municipality.escutcheon
    else
      municipality_logo = request.protocol + request.host_with_port + image_path("evenemang-allom-evenemangskalendern.png") 
    end  
    
    set_meta_tags( 
      :title => "Evenemang i #{@municipality.name}",
      :description => "Kolla in alla evenemang i #{@municipality.name}. Du kan också annonsera på Allom.",
      :canonical => "http://allom.se#{municipality_path(@municipality)}",
      :open_graph => {
        :title => @municipality.name,
        :type  => :activity,
        :url   => "http://allom.se#{municipality_path(@municipality)}" ,
        :image => municipality_logo,
        :site_name => "Allom - evenemangskalendern",
        }
      )
      
    content_for :head do  
      (raw "<link rel=\"image_src\" href=\"#{municipality_logo}\" />") + "\n" + auto_discovery_link_tag( :rss, municipality_url(:format => 'rss') , {:title => "Alla evenemang i #{@municipality.name} på Allom - evenemangskalendern."})
    end       
  end
  
  def local_organizers organizers, municipality
  
    unless organizers.count < 1
      str =%(
            <div id="local_organizers" class="box">
              <span class="heading">Våra aktivaste arrangörer:</span>
              <p>
                <ul>
            )
      for organizer in organizers.first(7) 
        str << %(
                  <li>
                    #{link_to (organizer[0].name + " (" + organizer[1].to_s + ")"), organizer_path(organizer[0]) } 
                  </li>)
      end
            
      str << %(
                </ul>
              </p>    
            </div>
              )
      raw str
    end
  end
  
  
  
  def admin_municipality  
    if current_user
      if current_user.is_admin? 
        str = ""
        str << %(
                  <div class = "user_message">
                    <h2>Administration av #{@municipality.name}</h2>
                    <p>Du är systemadministratör.</p>
                    
                    #{button_to t('.edit'), edit_municipality_path(@municipality), :method => :get }

                    #{ 
                      button_to(  
                        "Radera kommunsidan", 
                        @municipality, 
                        :confirm => "Är du säker att du vill radera kommunsidan för #{@municipality.name}? Det kommer inte gå att återskapa den och kopplingen till evenemangen kommer att förstöras. ", 
                        :method => :delete ) }

                    <p>
                      <strong>#{ Municipality.human_attribute_name 'admin_no' }: </strong>
                      #{ @municipality.admin_no }
                    </p>
                    <p>
                      <strong>#{ Municipality.human_attribute_name 'parent_admin_no' }: </strong>
                      #{ @municipality.parent_admin_no }
                    </p>
                    <p>
                      <strong>#{ Municipality.human_attribute_name 'short_name' }: </strong>
                      #{ @municipality.short_name }
                    </p>
                    <p>
                      <strong>#{ Municipality.human_attribute_name 'wikipedia_page' }:</strong>
                      #{ link_to "länk", @municipality.wikipedia_page }
                    </p>
                    <p>
                      <strong>#{ Municipality.human_attribute_name 'escutcheon' }:</strong>
                      #{ link_to "länk", @municipality.escutcheon }
                    </p>                                 
                  )
        unless @municipality.last_googleboted.blank? 
          str << %(
                      <p>
                        #{ t('.last_visited') + " " + l(@municipality.last_googleboted, :format => :default) + ' ' + t('.by_googlebot') }.
                      </p>
                  )
        end
      end
      raw str
    end
  end  
  
end
