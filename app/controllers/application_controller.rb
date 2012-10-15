require "application_responder"

class ApplicationController < ActionController::Base
  before_filter :check_uri
  before_filter http_basic_authenticate_with(:name => "smygtitt", :password => "tyst" ) if (ENV['ALLOM_LIVE']).blank?
  protect_from_forgery


  def check_uri
    if request.host.split('.')[0] == 'www'
      redirect_to request.protocol + request.host_with_port.gsub('www.',''), :status => 301
    end
  end

  protected 
  
  def map_marker event
		if event.stop_datetime < Time.now
      {
        "picture" => "#{ActionController::Base.helpers.asset_path('red-pushpin.png')}",
        "width" => 24,
        "height" => 24,
        "marker_anchor" => [ 16, 24]
      }
    else
      {
        "picture" => "#{ActionController::Base.helpers.asset_path('grn-pushpin.png')}",
        "width" => 32,
        "height" => 32,
        "marker_anchor" => [ 10, 32]
      }
		end		
	end

end
