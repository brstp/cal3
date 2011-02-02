ENV['RAILS_ENV'] || = 'production'
# Load the rails application
require File.expand_path('../application', __FILE__)

# Fix to be able to use generator in jquery_rails
# Check comment in:
# https://github.com/indirect/jquery-rails/issues/unreads#issue/17
#require 'openssl'
#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# Initialize the rails application
Cal3::Application.initialize!
