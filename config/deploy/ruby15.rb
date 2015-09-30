set :deploy_to, '/data/rails/evans-2015'
set :database_name, 'evans_2015'

role :web,     '2015.fmi.ruby.bg'
role :app,     '2015.fmi.ruby.bg'
role :db,      '2015.fmi.ruby.bg', primary: true
role :sidekiq, '2015.fmi.ruby.bg'
