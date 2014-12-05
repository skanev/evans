set :deploy_to, '/data/rails/evans-2013'
set :database_name, 'evans_2013'

role :web,     '2013.fmi.ruby.bg'
role :app,     '2013.fmi.ruby.bg'
role :db,      '2013.fmi.ruby.bg', primary: true
