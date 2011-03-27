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
    run "ln -nfs #{shared_path}/mail_settings    #{release_path}/config/mail_settings"
    run "ln -nfs #{shared_path}/uploads          #{release_path}/public/uploads"
  end
end

namespace :sync do
  task :db, :roles => :app do
    system <<-END
      ssh pyfmi@fmi.py-bg.net "pg_dump --format=c pyfmi | gzip -c" |
        gunzip -c |
        pg_restore --dbname=trane_development --clean --no-owner
    END
  end

  task :uploads, :roles => :app do
    system <<-END
      rsync --exclude tmp -av --delete \
        pyfmi@fmi.py-bg.net:#{shared_path}/uploads/ \
        public/uploads/
    END
  end

  task :secrets, :roles => :app do
    system "scp pyfmi@fmi.py-bg.net:#{shared_path}/pepper.txt config/pepper.txt"
    system "scp pyfmi@fmi.py-bg.net:#{shared_path}/secret_token.txt config/secret_token.txt"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

require 'config/boot'
require 'hoptoad_notifier/capistrano'
require 'bundler/capistrano'
