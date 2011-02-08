namespace :scrape do
  require 'nokogiri'
  require 'open-uri' 
  
  desc "Scrape municipality facts from Wikipedia."
  task :municipality_facts => :environment do 
    Municipality.all.each do |municipality|
      doc = Nokogiri::HTML(open(municipality.wikipedia_page))
      municipality.facts = doc.at_css(".geography").
              to_s.gsub(/<div.*kommunvapen.*<\/div>/, "").
              gsub(/\[.*\]/, "")
      municipality.facts_last_updated = Time.now
      municipality.save!
      puts "Fetched #{municipality.name}"
    end
    #url = "http://sv.wikipedia.org/wiki/Oskarshamns_kommun"
    #doc = Nokogiri::HTML(open(url))
    #m = Municipality.find_by_admin_no("0882") #Oskarshamn
    #m.facts = doc.at_css(".geography").to_s.gsub(/<div.*kommunvapen.*<\/div>/, "").gsub(/\[.*\]/, "")
    #TODO Timestamp      
    #m.save!
    #puts "Fetched " + m.short_name + "."
  end
  
  
  desc "Scrape list of all municipalities fom Wikipedia"
  task :municipalities => :environment do
    url = "http://sv.wikipedia.org/wiki/Lista_%C3%B6ver_Sveriges_kommuner"
    doc = Nokogiri::HTML(open(url))
    doc.xpath('//table[@class = "sortable wikitable"]/tr').each do |item|
      admin_code = item.at_css('td:nth-child(1)')
      wiki_link = item.at_css('td:nth-child(2) a')
      unless wiki_link.blank? or admin_code.blank?
        scb_code = admin_code.text[/[0-9][0-9][0-9][0-9]/].to_s.strip
        m = Municipality.find_or_create_by_admin_no scb_code
        m.wikipedia_page = "http://sv.wikipedia.org#{wiki_link[:href]}"
        m.save!
        #puts "DB: #{m.short_name} #{m.admin_no} Now:#{scb_code}"
      end
    end
  end
  
  
end
