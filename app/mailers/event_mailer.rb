class EventMailer < ActionMailer::Base
  # default :from => "Kalendern <no-reply@lumano.se>"
  # default :subject => "Ang. titel på evenemanget i kalendern"
  # default :to => "Stefan Pettersson <stefan.pettersson@lumano.se>"
  
  # def registration_confirmation(user)
    # @user = user
    # attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    # mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  # end
  
  def contact_event(mail_message)
    @mail_message = mail_message
    mail(   :from => 'Kalendern <no-reply@lumano.se>',
            :to => "#{mail_message.to_name} <#{mail_message.to_email}>", 
            :subject => "Ang. annonstitel" )
#    mail
  end
  
  # def set_request_vars(env)
    # request.user_ip, request.user_agent, request.referrer =
    # env['REMOTE_ADDR'], env['HTTP_USER_AGENT'], env['HTTP_REFERER']
  # end
  
end

