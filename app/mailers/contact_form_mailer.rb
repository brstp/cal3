# encoding: UTF-8
class ContactFormMailer < ActionMailer::Base
  default :from => "Allom <kundtjanst@allom.se>"
  default :to => "Allom <kundtjanst@allom.se>"

  
  def event_contact_person(mail_message)
    @mail_message = mail_message
    mail(   :from => "#{@mail_message.from_name} <#{@mail_message.from_email}>",
            :to => "#{@mail_message.to_name} <#{@mail_message.to_email}>",
            :subject => "#{@mail_message.subject}")
  end
    
  def copy_self_event_contact(mail_message)
    @mail_message = mail_message
    mail(   :to => "#{mail_message.from_name} <#{mail_message.from_email}>", 
            :subject => "Kopia: #{mail_message.subject}")
  end  
   
  def organizer_contact_person(mail_message)
    @mail_message = mail_message
    mail(   :from => "#{mail_message.from_name} <#{mail_message.from_email}>",
            :to => "#{mail_message.to_name} <#{mail_message.to_email}>", 
            :subject => "#{mail_message.subject}")
  end
      
  def copy_self_organizer_contact(mail_message)  
    @mail_message = mail_message
    mail(   :to => "#{mail_message.from_name} <#{mail_message.from_email}>", 
            :subject => "Kopia: #{mail_message.subject}")
  end
  
  def report_page_to_support(mail_message)  
    @mail_message = mail_message
    logger.info "*********************************"
    logger.info "----- #{@mail_message.from_name} <#{@mail_message.from_email}>"
    mail(   :from => "#{@mail_message.from_name} <#{@mail_message.from_email}>",
            :cc => "#{@mail_message.from_name} <#{@mail_message.from_email}>",
            :subject => "#{@mail_message.subject}")
  end  
    
end