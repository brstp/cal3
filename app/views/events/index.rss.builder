xml.instruct! :xml, :version => "1.0"
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:creativeCommons" => "http://backend.userland.com/creativeCommonsRssModule", "xmlns:atom" => "http://www.w3.org/2005/Atom"  do
  xml.channel do
    xml.title t 'rss.title'
    xml.atom(:link, :href => "#{request.protocol}#{request.host_with_port}#{request.fullpath}", :rel => :self, :type => "application/rss+xml")
    xml.description t 'rss.description'
    xml.link events_url(:format => 'rss')
    xml.language 'sv-SE'
    for event in @events
        xml.item do
          description = ""
          organized = ""
          xml.title "#{event.start_date} #{event.subject}"
          description << %(#{event.intro} <br /> ) unless params[:mute_intro]
          unless params[:intro]
            description << %(<strong>#{event.duration}</strong> <br />) unless params[:mute_duration]
            organized << %(av #{event.organizer.name} ) unless params[:mute_organizer]
            organized << %(i #{event.municipality.name} ) unless params[:mute_municipality]
            organized << %(i kategorin #{event.category.name} ) unless params[:mute_category]
            description << %(Arrangerat #{organized}. <br />) unless organized.blank?
            description << %(#{simple_format(event.description)} <br /> ) unless params[:mute_long]
            description << %(Sökord: #{params[:q]} <br />) unless ( params[:q].blank? || params[:mute_query] )
          end
          xml.description description unless params[:mute_description]
          xml.link event_url(event, :format => :html)
          xml.guid event_url(event, :isPermaLink => false)
          xml.tag!("creativeCommons:license", "http://creativecommons.org/licenses/by-sa/2.5/deed.sv")
          xml.pubDate event.created_at.rfc822
          #xml.geo :lat,  -43.526958 # latitude
          #xml.geo :long, 172.744217 # longitude
        end
    end
  end
end