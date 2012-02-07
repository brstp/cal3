source 'http://rubygems.org'

gem 'rails', '3.1.3'


# Use unicorn as the web server
# gem 'unicorn'



# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

#gem 'capistrano'                  #deploy

gem 'devise',           '~> 1.4.1'  #authentication
gem 'devise_invitable', '~> 0.5.4'
gem 'formtastic'                    #forms
gem "validation_reflection"         #validation of mandatory attributes
gem 'validates_timeliness'          #validate time/datetime
gem "mocha", :group => :test
gem 'sunspot_rails', '1.2.1' #'1.2.rc4'    #api classes for solr
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
gem 'will_paginate' , "3.0.pre2"     #well, to paginate
gem 'friendly_id', "~> 4.0.0"       # slugs, to make friendly urls
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'


group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem "nifty-generators"
  gem 'heroku'
  gem 'taps'
#  gem 'sunspot_solr'
end

group :production do
	#gem 'pg' 
end
