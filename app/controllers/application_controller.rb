require "application_responder"

class ApplicationController < ActionController::Base

  protect_from_forgery
  
  # http://groups.google.com/group/plataformatec-devise/tree/browse_frm/month/2010-06
  # def stored_location_for( resource )
    # if current_user
      # Rails.logger.info "count: " + current_user.sign_in_count.to_s
      # if current_user.sign_in_count <= 1
        # UserMailer.deliver_first_visit(current_user)
      # elsif ( current_user.first_name.blank? || current_user.last_name.blank? || current_user.phone.blank? || current_user.company_name.blank? )
         # set_flash_message :notice, 'Please update your profile'
         # return '/users/' + current_user.id.to_s + '/edit'
       # end
     # end
     # super( resource )
   # end 


  # http://stackoverflow.com/questions/4234442/devise-sign-in-and-redirect-never-seems-to-work
  # def stored_location_for(resource)
    # if current_user && params[:redirect_to]
      # flash[:notice] = "Congratulations, you're signed up!"
      # return params[:redirect_to]
    # end
    # super( resource ) 
  # end

   
end
