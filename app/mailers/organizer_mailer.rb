class OrganizerMailer < ActionMailer::Base
  default :from => "Svara inte - Foreningskalendern <noreply@foreningskalendern.se>"
  
  def new_event_confirmation(event, user)
    @user = user
    @event = event
    to_organizer = ""
    
    for dude in @event.organizer.users
      to_organizer += "#{dude.first_name} #{dude.last_name} <#{dude.email}>, "
    end
    
    mail(   :to => "#{to_organizer}", 
            :Precedence => "junk",
            :subject => "#{I18n.t('mail.new_event')}: #{event.subject}"   
          )
  end
  
  def changed_event_confirmation(event, user)
    @user = user
    @event = event
    to_organizer = ""
    
    for dude in @event.organizer.users
      to_organizer += "#{dude.first_name} #{dude.last_name} <#{dude.email}>, "
    end
    
    mail(   :to => "#{to_organizer}", 
            :Precedence => "junk",
            :subject => "#{I18n.t('mail.changed_event')}: #{event.subject}"   
          )
  end
  
  def deleted_event_confirmation
  end
  
  def new_member_confirmation
  end
  
  def deleted_member_confirmation
  end
  
  def contact_person_confirmation
  end
end
