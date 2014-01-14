set :deploy_to, '/data/rails/pyfmi-2014'
set :database_name, 'pyfmi_2014'

role :web,     'fmi.py-bg.net'
role :app,     'fmi.py-bg.net'
role :db,      'fmi.py-bg.net', primary: true
role :sidekiq, 'fmi.py-bg.net'
