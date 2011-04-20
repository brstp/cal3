class OrganizerMailer < ActionMailer::Base
  default :from => "Kalendern <noreply@foreningskalendern.se>"
  
  def new_event_confirmation(event, user)
    @user = user
    @event = event
    to_organizer = ""
    
    for dude in @event.organizer.users
      to_organizer += "#{dude.first_name} #{dude.last_name} <#{dude.email}>, "
    end
    
    mail(   :to => "#{to_organizer}", 
            :Precedence => "junk",
            :subject => "#{I18n.t('event.mail.new')}: #{event.subject}"   
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
            :subject => "#{I18n.t('event.mail.changed')}: #{event.subject}"   
          )
  end
  
  def new_petition(petition, current_user)
    @user = current_user
    @petition = petition
    @organizer = @petition.organizer
    @wannabe = @petition.user 
    to_organizer = ""
    for dude in @organizer.users
      to_organizer += (dude.name + ',')
    end
    
    mail(   :to => "#{to_organizer}", 
            :cc => "#{@wannabe}",
            :subject => "#{I18n.t('petition.mail.new')} #{@organizer}"   
          )    
    
  end
  
  def approved_petition(petition, current_user)
    @user = current_user
    @petition = petition
    @organizer = @petition.organizer
    @wannabe = @petition.user 
    cc_organizer = ""
    for dude in @organizer.users
      cc_organizer += (dude.name + ',')
    end
    
    mail(   :cc => "#{cc_organizer}", 
            :to => "#{@wannabe}",
            :Precedence => "junk",
            :subject => "#{I18n.t('petition.mail.approved')} #{@organizer}"   
          )    
    
  end

  def rejected_petition(petition, current_user)
    @user = current_user
    @petition = petition
    @organizer = @petition.organizer
    @wannabe = @petition.user 
    cc_organizer = ""
    for dude in @organizer.users
      cc_organizer += (dude.name + ',')
    end
    
    mail(   :cc => "#{cc_organizer}", 
            :to => "#{@wannabe}",
            :Precedence => "junk",
            :subject => "#{I18n.t('petition.mail.rejected')} #{@organizer}"   
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
