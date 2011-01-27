class EventMailer < ActionMailer::Base
  
  def contact_event(mail_message)
    @mail_message = mail_message
    mail(   :from => "#{mail_message.from_name} <#{mail_message.from_email}>",
            :to => "#{mail_message.to_name} <#{mail_message.to_email}>", 
            :subject => "Angående evenemang: #{Event.find(mail_message.event_id).subject}" )
  end
  
  def copy_event_sender(mail_message)
    @mail_message = mail_message
    mail(   :from => I18n.t('app.no_reply_name') + '<' + I18n.t('app.no_reply_email')+ '>',
            :to => "#{mail_message.from_name} <#{mail_message.from_email}>", 
            :subject => "Kopia evenemang: #{Event.find(mail_message.event_id).subject}" )
  end  
  
    
end

