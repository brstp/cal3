xml.instruct! :xml, :version => "1.0"
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:creativeCommons" => "http://backend.userland.com/creativeCommonsRssModule", "xmlns:atom" => "http://www.w3.org/2005/Atom", "xmlns:geo" => "http://www.w3.org/2003/01/geo/wgs84_pos#" do
  xml.channel do
    title = "Evenemang från Allom."
    if params[:sbo_id].present?
      title = "Evenemang som #{Organizer.find(params[:sbo_id])} rekommenderar i Allom."
    else
      if params[:organizer_id].present?
        title = "#{Organizer.find(params[:organizer_id]).s} evenemang i Allom."
      else
        if params[:municipality_id].present?
          title = "Evenemang i #{Municipality.find(params[:municipality_id]).name} i Allom."
        end
      end
    end
    
    xml.title title
    xml.atom(:link, :href => "#{request.protocol}#{request.host_with_port}#{request.fullpath}", :rel => :self, :type => "application/rss+xml")
    xml.description "Allom - kalendern med allt som händer innan det är för sent. Du kan själv annonsera dina evenemang på Allom."
    xml.link "http://allom.se"
    xml.language 'sv-SE'
    unless @events.blank?
      for event in @events
          xml.item do
            description = ""
            if params[:img] && (event.image1.exists?)
              description << %(#{link_to(image_tag(image_path(event.image1.url(:small)), :class => "allom_image", :alt => "#{event.subject} (#{event.category.name}). #{event.organizer.name}, #{event.municipality.short_name}. #{l(event.start_datetime)}."),  event_url(event), :title => "#{event.subject} (#{event.category.name}). #{event.organizer.name}, #{event.municipality.short_name}. #{l(event.start_datetime)}.", )})
            end 
            organized = ""
            unless params[:mute_date]
              title = "#{event.start_date} #{event.subject}" 
            else
              title = "#{event.subject}" 
            end
             
            xml.title title
            description << %(#{event.intro}) unless params[:mute_intro]
            unless params[:intro]
              description << %(<br /><strong>#{event.duration}</strong><br />) unless params[:mute_duration]
              organized << %( av #{event.organizer.name}) unless params[:mute_organizer]
              organized << %( i #{event.municipality.name}) unless params[:mute_municipality]
              organized << %( i kategorin #{event.category.name}) unless params[:mute_category]
              description << %(Arrangerat#{organized}.<br />) unless organized.blank?
              description << %(#{simple_format(event.description)}<br /> ) unless params[:mute_long]
            end
            xml.description {xml.cdata!(description)} unless params[:mute_description]
            xml.link event_url(event)
            xml.guid event_url(event)
            xml.tag!("creativeCommons:license", "http://creativecommons.org/licenses/by-sa/2.5/deed.sv")
            #xml.pubDate       event.created_at.to_s(:rfc822)
            unless event.lat.nil? || event.lng.nil?
              xml.geo :lat,  "#{event.lat}"
              xml.geo :long, "#{event.lng}"
            end
          end
      end
    else
      
      xml.item do
        xml.title "Inga evenemang på Allom matchar exakt nu."
        xml.link events_url
        xml.guid events_url
      end
            
      unless params[:organizer_id].blank?
        organizer = Organizer.find(params[:organizer_id])
        unless organizer.nil?
          xml.item do
            xml.title "Arrangören #{organizer.s} evenemangskalender."
            xml.link organizer_url(organizer)
            xml.guid organizer_url(organizer)
          end
        end
      end

      unless params[:municipality_id].blank?
        municipality = Municipality.find(params[:municipality_id])
        unless municipality.nil?
          xml.item do
            xml.title "Evenemang och aktiviteter i #{municipality.name}."
            xml.link municipality_url(municipality)
            xml.guid municipality_url(municipality)
          end
        end
      end

      unless params[:category_facet_id].blank?
        category = Category.find(params[:category_facet_id])
        unless category.nil?
          xml.item do
            xml.title "Evenemang inom #{category.name}."
            xml.link events_url(:category_facet_id => category.id)
            xml.guid events_url(:category_facet_id => category.id)
          end
        end
      end
            
      unless params[:c1_id].blank?
        category = Category.find(params[:c1_id])
        unless category.nil?
          xml.item do
            xml.title "Evenemang inom #{category.name}."
            xml.link events_url(:c1_id => category.id)
            xml.guid events_url(:c1_id => category.id)
          end
        end
      end      

      unless params[:c2_id].blank?
        category = Category.find(params[:c2_id])
        unless category.nil?
          xml.item do
            xml.title "Evenemang inom #{category.name}."
            xml.link events_url(:c2_id => category.id)
            xml.guid events_url(:c2_id => category.id)
          end
        end
      end      

      unless params[:c3_id].blank?
        category = Category.find(params[:c3_id])
        unless category.nil?
          xml.item do
            xml.title "Evenemang inom #{category.name}."
            xml.link events_url(:c3_id => category.id)
            xml.guid events_url(:c3_id => category.id)
          end
        end
      end      

      unless params[:sbo_id].blank?
        organizer = Organizer.find(params[:sbo_id])
        unless organizer.nil?
          xml.item do
            xml.title "Evenemang som rekommenderas av #{organizer.name}."
            xml.link organizer_url(organizer)
            xml.guid organizer_url(organizer)
          end
        end
      end
      
      xml.item do
        xml.title "Egen kalender för evenemang på din hemsida/blogg."
        xml.link "http://info.allom.se/egen-evenemangskalender/"
        xml.guid "http://info.allom.se/egen-evenemangskalender/"
      end
      
    end
  end
end