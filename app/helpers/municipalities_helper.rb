module MunicipalitiesHelper
  def local_organizers organizers, municipality
  
    unless organizers.count < 1
      str =%(
            <div id="local_organizers" class="box">
              <span class="heading">#{t('.local_organizers') + ' ' + municipality.name}:</span>
              <p>
                <ul>
            )
      for organizer in organizers 
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
end
