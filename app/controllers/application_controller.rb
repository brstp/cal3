# encoding: UTF-8

require "application_responder"

class ApplicationController < ActionController::Base
  before_filter :check_uri
  before_filter http_basic_authenticate_with(:name => "smygtitt", :password => "tyst" ) if (ENV['ALLOM_LIVE']).blank?
  #before_filter http_basic_authenticate_with(:name => "kolla", :password => "kolla" ) if (ENV['ALLOM_DEMO']).present?
  
  before_filter :demo_mode?, :except => [:show, :index]

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

  def remove_admin_params
    params[:user].delete(:is_admin) unless current_user.try(:is_admin)
  end


  def demo_mode?
    if (ENV['ALLOM_DEMO']).present?
      flash[:alert] = "Hej! Det här är en smygtitt av nästa version av Allom. Här går det inte att spara, radera eller ändra något. Gå till \"vanliga\" allom.se om du vill lägga in eller ändra något. Allt som ligger där kommer att flyttas med när vi kör igång den nya versionen."
        redirect_to :back
    end
  end

end
