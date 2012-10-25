require "application_responder"

class ApplicationController < ActionController::Base
  before_filter :check_uri
  protect_from_forgery


  def check_uri
    if request.host.split('.')[0] == 'www'
      redirect_to request.protocol + request.host.gsub('www.',''), :status => 301
    end
  end

protected

  def remove_admin_params
    params[:user].delete(:is_admin) unless current_user.try(:is_admin)
  end

end
