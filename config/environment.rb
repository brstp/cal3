# Load the rails application
require File.expand_path('../application', __FILE__)

# Fix to be able to use generator in jquery_rails
# Check comment in:
# https://github.com/indirect/jquery-rails/issues/unreads#issue/17
#require 'openssl'
#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Rails::Application::Configuration
 def database_configuration
  require 'erb'
  YAML::load(ERB.new(IO.read(database_configuration_file)).result).each_value {|env| env.merge!({"encoding" => "utf8", "collation" => "utf8_general_ci"}) }
  end
end

# Initialize the rails application
Cal3::Application.initialize!
