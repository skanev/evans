set :deploy_to,   '/data/rails/evans-2012'
role :web, 'fmi.ruby.bg'
role :app, 'fmi.ruby.bg'
role :db,  'fmi.ruby.bg', :primary => true

set :database_name, 'evans_2012'
