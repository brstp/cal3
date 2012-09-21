source 'http://rubygems.org'

gem 'rails', "3.1.3"



# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end


gem 'devise',           '>= 2.0.0'  #authentication
gem 'devise_invitable', '~> 1.0.0'
gem 'formtastic'                    #forms
#gem "validation_reflection"         #validation of mandatory attributes
gem 'validates_timeliness'          #validate time/datetime
gem "mocha", :group => :test
gem 'sunspot_rails' #, '1.2.1' #'1.2.rc4'    #api classes for solr
gem 'mail_form'                     #needed? used? TODO
gem 'timeliness'
gem "geocoder"                      #server side geo coding
gem 'meta-tags', :require => 'meta_tags'  #header tags
gem "paperclip", "2.3.16"                    #upload and organizer images
gem "ancestry"                      #tree structure
gem 'yaml_db'                       #dump, load db as yaml 
gem 'nokogiri'                      #parse
gem 'icalendar'                     #create ical events
gem 'heroku'                        #remote control for prod env at Heroku
gem 'aws-s3'                        #API towards Amazon Web Services
#gem  'aws-sdk'
#gem 'will_paginate' , "3.0.pre2"     #well, to paginate
gem 'friendly_id'#, "~> 4.0.0"       # slugs, to make friendly urls
gem 'pg'
#gem 'mysql'
gem 'kaminari'          # pagination
gem "sunspot_with_kaminari" #, '~> 0.1'

gem 'progress_bar'

gem 'haml'
gem 'haml-rails'
gem 'html5-rails' # there is a bug in flashes, made monkey patch 
gem 'gmaps4rails'
gem "delayed_job"
gem 'delayed_job_active_record'
gem "delayed_job_web" # todo: set up passwd protection or disable

gem "thin"

  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails' #, "~> 3.2.1"
  gem 'uglifier' #, '>= 1.0.3'
  gem 'sass-rails' #, '~> 3.2.3'
  gem 'compass' #, '0.12.alpha.4'
  gem 'compass-h5bp'
  #gem 'jquery-rails'
  #gem 'jquery-ui-rails'
end


group :development, :test do
  gem 'sqlite3-ruby' #, :require => 'sqlite3'
  gem "nifty-generators"
  gem 'heroku'
  gem 'taps'
  gem 'sunspot_solr' #, '1.3.0'
  
end

group :production do
	#gem 'pg' 
  
end