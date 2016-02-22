set :deploy_to, '/data/rails/pyfmi-2015'
set :database_name, 'pyfmi_2015'

role :web,     '2016.fmi.py-bg.net'
role :app,     '2016.fmi.py-bg.net'
role :db,      '2016.fmi.py-bg.net', primary: true
role :sidekiq, '2016.fmi.py-bg.net'
