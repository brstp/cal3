Cal3::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  config.action_mailer.default_url_options = { :host => 'allom.se' }
  
  # Compress JavaScripts and CSS
  config.assets.compress = true
  config.assets.js_compressor = :closure

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }

  ActionMailer::Base.delivery_method = :smtp    
  
  
  

  if (ENV['ALLOM_LIVE']).blank?
    config.paperclip_defaults = {
        :storage => :fog,
        :fog_public => true,
        :fog_directory => 'stage.allom.se',
        :fog_host => 'http://stage.allom.se.s3-external-3.amazonaws.com',
        :fog_credentials => {
          :aws_access_key_id => ENV['S3_KEY'],
          :aws_secret_access_key => ENV['S3_SECRET'],
          :provider => 'AWS',
          :region => 'eu-west-1'
        }
      }
  else
    config.paperclip_defaults = {
        :storage => :fog,
        :fog_public => true,
        :fog_directory => 'static.allom.se',
        :fog_host => 'http://static.allom.se.s3.amazonaws.com',
        :fog_credentials => {
          :aws_access_key_id => ENV['S3_KEY'],
          :aws_secret_access_key => ENV['S3_SECRET'],
          :provider => 'AWS'
        }
      }
  end  
      

end
