set :application, "Trane Revisited"
set :repository,  "git://github.com/fmi/trane.git"

set :scm, :git
set :use_sudo, false

role :web, "fmi.py-bg.net"
role :app, "fmi.py-bg.net"
role :db,  "fmi.py-bg.net", :primary => true

set :user, :pyfmi
set :deploy_to, '/data/rails/pyfmi'

namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/database.yml     #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/secret_token.txt #{release_path}/config/secret_token.txt"
    run "ln -nfs #{shared_path}/pepper.txt       #{release_path}/config/pepper.txt"
    run "ln -nfs #{shared_path}/uploads          #{release_path}/public/uploads"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

require 'config/boot'
require 'hoptoad_notifier/capistrano'
require 'bundler/capistrano'
