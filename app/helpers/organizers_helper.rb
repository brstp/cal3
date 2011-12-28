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
end
