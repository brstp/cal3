xml.instruct! :xml, :version => "1.0"
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:creativeCommons" => "http://backend.userland.com/creativeCommonsRssModule"  do
  xml.channel do
    xml.title t 'rss.title'
    xml.description t 'rss.description'
    xml.link events_url(:format => 'rss')
    xml.language 'sv-SE'

    #xml.atom( :link, :href => events_url(:format => 'rss'), :rel => "self", :type => "application/rss+xml" )
    for event in @events
        xml.item do
          xml.title event.start_date + ' ' + event.subject
          xml.description event.intro + '<br /><strong>' + event.duration + '</strong><br>' + t('app.arranged_by') + ' ' + event.organizer.name + ' ' + t('app.in_municipality') + ' ' + event.municipality.name + '<br />' + simple_format(event.description)
          xml.link event_url(event, :format => :html)
          xml.guid event_url(event, :isPermaLink => false)
          xml.tag!("creativeCommons:license", "http://creativecommons.org/licenses/by-sa/2.5/deed.sv")
          xml.pubDate I18n.l(event.created_at, :format => :machine)
          #xml.geo :lat,  -43.526958 # latitude
          #xml.geo :long, 172.744217 # longitude
        end
    end
  end
end
