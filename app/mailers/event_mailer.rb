class EventMailer < ActionMailer::Base
  
  def contact_event(mail_message)
    @mail_message = mail_message
    mail(   :from => "#{mail_message.from_name} <#{mail_message.from_email}>",
            :to => "#{mail_message.to_name} <#{mail_message.to_email}>", 
            :subject => "#{mail_message.subject}")
  end
  
  def copy_event_sender(mail_message)
    @mail_message = mail_message
    mail(   :from => "Alloms automatiska mejl <kundtjanst@allom.se>",
            :to => "#{mail_message.from_name} <#{mail_message.from_email}>", 
            :subject => "Kopia: #{mail_message.subject}")
  end  
   
end