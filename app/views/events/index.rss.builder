xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Kalendern"
    xml.description "Allt som hender"
    xml.link "http://127.0.0.1:3000/"
    for event in @events.find(:conditions => ["stop_datetime >= '#{Time.now}'"])
      @events.each do |event|
        xml.item do
          xml.title event.subject
          xml.description event.intro + '<br>' + event.description
          xml.link event_path(event, :format => :rss)
          xml.guid event_url(event, :format => :html)
        end
      end
    end
  end
end

#   for event in @events.find(:all, :conditions => ["stop_datetime >= '#{Time.now}'"], :order => "start_datetime ASC")