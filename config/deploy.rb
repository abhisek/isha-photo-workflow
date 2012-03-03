set :application, "ishaphoto"
#set :deploy_to, "/home/npinfotech/#{application}"
set :deploy_to, "/var/apps/#{application}"
set :repository,  "."

set :scm, :none
set :deploy_via, :copy
set :copy_exclude, [".git", ".gitignore"]

set :user, "web"
set :use_sudo, false

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "eugene.3slabs.com"                          # Your HTTP server, Apache/etc
role :app, "eugene.3slabs.com"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:update_code" do
  run "rm -rf #{release_path}/config/database.yml"
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

before :deploy do
  system("bundle exec rake assets:precompile")
end

after :deploy do
  system("bundle exec rake assets:clean")
end
