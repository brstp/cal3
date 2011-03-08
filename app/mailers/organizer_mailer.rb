class OrganizerMailer < ActionMailer::Base
  default :from => "Svara inte - Foreningskalendern <noreply@foreningskalendern.se>"
  # def contact_event(mail_message)
    # @mail_message = mail_message
    # mail(   :from => "#{mail_message.from_name} <#{mail_message.from_email}>",
            # :to => "#{mail_message.to_name} <#{mail_message.to_email}>", 
            # :subject => "#{I18n.t('mail.to_event')}: #{Event.find(mail_message.event_id).subject}" )
  # end
  
  
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
  
end
