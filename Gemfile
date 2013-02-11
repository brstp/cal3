source 'http://rubygems.org'

gem 'rails', "3.2.11"
gem "thin"
#gem 'heroku'                        #remote control for prod env at Heroku. Needed here too?
gem 'pg'


gem 'devise',           '>= 2.1.2'  #authentication
gem 'devise_invitable', '~> 1.0.0'  #invite new users

gem 'formtastic'                    #forms
gem 'validates_timeliness'          #validate time/datetime
gem 'timeliness'

gem 'sunspot_rails' #, '1.2.1' #'1.2.rc4'    #api classes for solr
gem 'kaminari'          # pagination
gem "sunspot_with_kaminari" #, '~> 0.1'

gem "cocaine", "0.3.2"
gem "paperclip", "~> 3.0" #, "2.3.16"                    #upload and organizer images
#gem 'aws-sdk', '~> 1.3.4'
gem "fog"
gem 'friendly_id'#, "~> 4.0.0"       # slugs, to make friendly urls


gem 'gmaps4rails'
gem "geocoder"                      #server side geo coding. Used? TODO

gem 'meta-tags', :require => 'meta_tags'  #header tags. TODO Used?

gem "ancestry"                      #tree structure


gem 'nokogiri'                      #parse
gem 'icalendar'                     #create ical events



gem 'haml'
gem 'haml-rails'
gem 'html5-rails' # there is a bug in flashes, made monkey patch 



gem "delayed_job"
gem 'delayed_job_active_record'
gem "delayed_job_web" # todo: set up passwd protection or disable
gem 'devise-async'
#gem 'delayed_paperclip'
#gem 'delayed_paperclip'    , '2.4.5.2', :git => 'git://github.com/tommeier/delayed_paperclip', :branch => 'fix_312'
#gem 'delayed_paperclip', :git => 'git://github.com/tommeier/delayed_paperclip.git', :ref => '98a8b9e0c24d24c94e2c9c39a704c1b07c5c4d6b'  
#gem 'delayed_paperclip', :git => 'git://github.com/jrgifford/delayed_paperclip.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails' #, "~> 3.2.1"
  gem 'uglifier' #, '>= 1.0.3'
  gem 'sass-rails' #, '~> 3.2.3'
  gem 'compass-rails'
  #gem 'compass' #, '0.12.alpha.4'
  gem 'compass-h5bp'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
end


gem "mocha", :group => :test


group :development, :test do
  gem 'sqlite3-ruby' #, :require => 'sqlite3'
  #gem "nifty-generators"
  gem 'heroku'
  #gem 'taps'
  gem 'sunspot_solr' #, '1.3.0'  
end

group :production do
	#gem 'pg' 
	gem 'devise',           '>= 2.1.2'
end