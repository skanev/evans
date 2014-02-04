set :deploy_to, '/data/rails/evans-2011'
set :database_name, 'evans_2011'

role :web,     '2011.fmi.ruby.bg'
role :app,     '2011.fmi.ruby.bg'
role :db,      '2011.fmi.ruby.bg', primary: true
