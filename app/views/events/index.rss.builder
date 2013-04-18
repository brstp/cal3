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
    for event in @events
        xml.item do
          description = ""
          if params[:img] && (event.image1.exists?)
            description << %(#{link_to(image_tag(image_path(event.image1.url(:small)), :class => "allom_image", :alt => "#{event.subject} (#{event.category.name}). #{event.organizer.name}, #{event.municipality.short_name}. #{l(event.start_datetime)}."),  event_url(event), :title => "#{event.subject} (#{event.category.name}). #{event.organizer.name}, #{event.municipality.short_name}. #{l(event.start_datetime)}.", )})
          end 
          organized = ""
          xml.title "#{event.start_date} #{event.subject}"
          description << %(#{event.intro}<br />) unless params[:mute_intro]
          unless params[:intro]
            description << %(<strong>#{event.duration}</strong><br />) unless params[:mute_duration]
            organized << %( av #{event.organizer.name}) unless params[:mute_organizer]
            organized << %( i #{event.municipality.name}) unless params[:mute_municipality]
            organized << %( i kategorin #{event.category.name}) unless params[:mute_category]
            description << %(Arrangerat#{organized}.<br />) unless organized.blank?
            description << %(#{simple_format(event.description)}<br /> ) unless params[:mute_long]
          end
          xml.description {xml.cdata!(description)} unless params[:mute_description]
          xml.link event_url(event)
          xml.guid event_url(event, :isPermaLink => false)
          xml.tag!("creativeCommons:license", "http://creativecommons.org/licenses/by-sa/2.5/deed.sv")
          #xml.pubDate       event.created_at.to_s(:rfc822)
          unless event.lat.nil? || event.lng.nil?
            xml.geo :lat,  "#{event.lat}"
            xml.geo :long, "#{event.lng}"
          end
        end
    end
  end
end