set :deploy_to, '/data/rails/evans-2014'
set :database_name, 'evans_2014'

role :web,     '2014.fmi.ruby.bg'
role :app,     '2014.fmi.ruby.bg'
role :db,      '2014.fmi.ruby.bg', primary: true
role :sidekiq, '2014.fmi.ruby.bg'
