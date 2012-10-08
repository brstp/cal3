class ContactFormMailer < ActionMailer::Base
  default from: "kundtjanst@allom.se"
  default to: "stefan@lumano.se"
  
  def event_contact_person(mail_message)
    @mail_message = mail_message
    mail(   :from => "#{@mail_message.from_name} <#{@mail_message.from_email}>",
            :to => "#{@mail_message.to_name} <#{@mail_message.to_email}>", 
            :subject => "#{@mail_message.subject}")
  end
  
  def copy_self_event_contact(mail_message)
    @mail_message = mail_message
    mail(   :from => "Alloms automatiska mejl <kundtjanst@allom.se>",
            :to => "#{mail_message.from_name} <#{mail_message.from_email}>", 
            :subject => "Kopia: #{mail_message.subject}")
  end  
   
  def organizer_contact_person(mail_message)
    @mail_message = mail_message
    mail(   :from => "#{mail_message.from_name} <#{mail_message.from_email}>",
            :to => "#{mail_message.to_name} <#{mail_message.to_email}>", 
            :subject => "#{mail_message.subject}")
  end
  
  def copy_self_organizer_contact_person(mail_message)  
    @mail_message = mail_message
    mail(   :from => "#{mail_message.from_name} <#{mail_message.from_email}>",
            :to => "#{mail_message.to_name} <#{mail_message.to_email}>", 
            :subject => "#{mail_message.subject}")
  end
  
  def report_page(mail_message)  
    @mail_message = mail_message
    mail(   :from => "#{mail_message.from_name} <#{mail_message.from_email}>",
            :to => "#{mail_message.to_name} <#{mail_message.to_email}>", 
            :subject => "#{mail_message.subject}")
  end  
    
end
