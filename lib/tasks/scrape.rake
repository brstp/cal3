namespace :scrape do
  require 'nokogiri'
  require 'open-uri' 
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  
  desc "Scrape municipality facts from Wikipedia."
  task :update_facts => :environment do 
    Municipality.all.each do |municipality|
      puts "Fetching #{municipality.name}"
      doc = Nokogiri::HTML(open(municipality.wikipedia_page))
      municipality.facts = auto_link(sanitize( doc.at_css(".geography").
                to_s.gsub(/<div.*kommunvapen.*<\/div>/, "").
                to_s.gsub(/<div.*stadsvapen.*<\/div>/, "").
                gsub(/\[.*\]/, ""), 
                  :tags => %w(table div tbody th tr td img br ), 
                  :attributes => %w(class id src alt colspan)), 
                    :urls, :rel => :no_follow).
                gsub(/<img.*Portal.*/,"").
                gsub(/<td colspan="2">.*\ stad<\/td>/, "").
                gsub(/<td colspan="2">.*\ kommun<\/td>/, "<td class = 'municipality_name' colspan = '2'>#{municipality.name}</td>").
                gsub(/<td colspan="2">Kommun<\/td>/, "")
      unless doc.at_css('.mergedrow img').blank?
        municipality.escutcheon = doc.at_css('.mergedrow img')[:src]
      else
        municipality.escutcheon = "/images/municipalities/escutcheons/medium/missing.png"
      end
      municipality.facts_last_updated = Time.now
      municipality.save!  
    end
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
