set :stages, %w(ruby12 python13 clojure13)
set :default_stage, File.read('config/default_stage').strip if File.exist?('config/default_stage')
require 'capistrano/ext/multistage'

set :application,   'Trane Revisited'
set :scm,           :git
set :repository,    'git://github.com/skanev/evans.git'
set :branch,        'multiple-languages'
set :user,          'pyfmi'
set :user_and_host, 'pyfmi@deedee.hno3.org'
set :use_sudo,      false

set :normalize_asset_timestamps, false

namespace :deploy do
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :setup_gems, :except => {:no_release => true} do
    run "ln -nfs #{shared_path}/bundle #{release_path}/vendor/bundle"
    run "cd '#{release_path}' && bundle install --deployment"
  end

  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/site.yml     #{release_path}/config/site.yml"
    run "ln -nfs #{shared_path}/lectures     #{release_path}/public/lectures"
    run "ln -nfs #{shared_path}/uploads      #{release_path}/public/uploads"
  end

  namespace :assets do
    task :precompile do
      run "cd #{release_path} && bundle exec rake assets:precompile"
    end
  end
end

after 'deploy:update_code', 'deploy:setup_gems'
after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:update_code', 'deploy:assets:precompile'

namespace :lectures do
  desc 'Regenerate the lectures from the GitHub repo'
  task :update, roles: :app do
    run "cd #{current_path} && script/lectures"
  end
end

namespace :sync do
  desc 'Fetch the production database'
  task :db, :roles => :app do
    system <<-END
      ssh #{user_and_host} "pg_dump --clean #{database_name} | gzip -c" |
        gunzip -c |
        bundle exec rails dbconsole
    END
  end

  desc 'Fetch the images uploaded in production'
  task :uploads, :roles => :app do
    system <<-END
      rsync --exclude tmp -av --delete \
        #{user_and_host}:#{shared_path}/uploads/ \
        public/uploads/
    END
  end
end

require './config/boot'
require 'sidekiq/capistrano'
