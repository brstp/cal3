require 'bundler/capistrano'
set :application, "cal3"
set :repository,  "git@github.com:brstp/cal3.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "deployer"
set :scm_username, "brstp"
set :deploy_to, "/var/www/www.foreningskalendern.se"
set :use_sudo, false



role :web, "www.foreningskalendern.se"                          # Your HTTP server, Apache/etc
role :app, "www.foreningskalendern.se"                          # This may be the same as your `Web` server
role :db,  "www.foreningskalendern.se", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
  run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end