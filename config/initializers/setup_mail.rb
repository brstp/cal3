

# ActionMailer::Base.smtp_settings = {
  # :address              => "smtp.gmail.com",
  # :port                 => 587,
  # :domain               => "mumin.nu",
  # :user_name            => "b.r.stefan.pettersson",
  # :password             => "norrviken",
  # :authentication       => "plain",
  # :enable_starttls_auto => true
# }

# ActionMailer::Base.smtp_settings = {
  # :address              => "192.168.0.1",
  # :port                 => 25,
  # :domain               => "lumano.se",
  # :user_name            => "b.r.stefan.pettersson",
  # :password             => "norrviken",
  # :authentication       => "plain",
  # :enable_starttls_auto => true
# }

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = "stefan.pettersson@lumano.se"
  end
end

ActionMailer::Base.default_url_options[:host] = "127.0.0.1:3000"
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) #if Rails.env.development?

