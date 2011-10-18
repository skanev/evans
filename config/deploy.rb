set :application, 'Trane Revisited'
set :scm,         :git
set :repository,  'git://github.com/skanev/evans.git'
set :deploy_to,   '/data/rails/evans'
set :user,        'pyfmi'
set :use_sudo,    false

role :web, 'fmi.ruby.bg'
role :app, 'fmi.ruby.bg'
role :db,  'fmi.ruby.bg', :primary => true

set :normalize_asset_timestamps, false

namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :setup_gems, :except => {:no_release => true} do
    run "mkdir -p '#{shared_path}/bundled_gems'; ln -nfs '#{shared_path}/bundled_gems' #{release_path}/vendor/bundle"
    run "cd '#{release_path}' && bundle install --deployment && cd -"
  end

  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/database.yml     #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/secret_token.txt #{release_path}/config/secret_token.txt"
    run "ln -nfs #{shared_path}/pepper.txt       #{release_path}/config/pepper.txt"
    run "ln -nfs #{shared_path}/mail_settings    #{release_path}/config/mail_settings"
    run "ln -nfs #{shared_path}/lectures         #{release_path}/public/lectures"
    run "ln -nfs #{shared_path}/uploads          #{release_path}/public/uploads"
  end

  namespace :assets do
    task :precompile do
      run "cd #{release_path} && RAILS_ENV=production RAILS_GROUPS=assets bundle exec rake assets:precompile"
    end
  end
end

after 'deploy:update_code', 'deploy:setup_gems'
after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:update_code', 'deploy:assets:precompile'

namespace :lectures do
  task :update, roles: :app do
    run "cd #{current_path} && script/lectures"
  end
end

namespace :sync do
  task :db, :roles => :app do
    # gather local connection options
    local_db_config_file = File.expand_path('../database.yml', __FILE__)
    local_db_config = YAML::load(File.read(local_db_config_file))['development']

    connect_options = %w(host port username).map do |option|
      "--#{option}='#{local_db_config[option]}'" if local_db_config[option]
    end.compact.join(' ')
    connect_options << '--password' if local_db_config[password].to_s != ''

    system <<-END
      ssh pyfmi@fmi.ruby.bg "pg_dump --format=c evans | gzip -c" |
        gunzip -c |
        pg_restore #{connect_options} --clean --no-owner --dbname=#{local_db_config['database']}
    END
  end

  task :uploads, :roles => :app do
    system <<-END
      rsync --exclude tmp -av --delete \
        pyfmi@fmi.ruby.bg:#{shared_path}/uploads/ \
        public/uploads/
    END
  end

  task :secrets, :roles => :app do
    system "scp pyfmi@fmi.py-bg.net:#{shared_path}/pepper.txt config/pepper.txt"
    system "scp pyfmi@fmi.py-bg.net:#{shared_path}/secret_token.txt config/secret_token.txt"
  end
end

require './config/boot'
require 'airbrake/capistrano'
