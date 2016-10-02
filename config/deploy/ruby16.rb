set :deploy_to, '/data/rails/evans-2016'
set :database_name, 'evans_2016'

role :web,     '2016.fmi.ruby.bg'
role :app,     '2016.fmi.ruby.bg'
role :db,      '2016.fmi.ruby.bg', primary: true
role :sidekiq, '2016.fmi.ruby.bg'
