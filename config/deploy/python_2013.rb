set :deploy_to,   '/data/rails/pyfmi-2013'
role :web, 'fmi.py-bg.net'
role :app, 'fmi.py-bg.net'
role :db,  'fmi.py-bg.net', :primary => true
