# This file is used by Rack-based servers to start the application.


#DelayedJobWeb.use Rack::Auth::Basic do |username, password|
#  username == 'admin'
#  password == 'weird'
#end

require ::File.expand_path('../config/environment',  __FILE__)
run Cal3::Application