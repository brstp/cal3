require "application_responder"

class ApplicationController < ActionController::Base
  before_filter :check_uri
  protect_from_forgery


  def check_uri
    redirect_to request.protocol + request.host_with_port.gsub("/www\.//g") + request.request_uri if /^www/.match(request.host)
  end


end
