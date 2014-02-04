set :deploy_to, '/data/rails/evans-2012'
set :database_name, 'evans_2012'

role :web,     '2012.fmi.ruby.bg'
role :app,     '2012.fmi.ruby.bg'
role :db,      '2012.fmi.ruby.bg', primary: true
