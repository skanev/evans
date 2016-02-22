set :deploy_to, '/data/rails/pyfmi-2014'
set :database_name, 'pyfmi_2014'

role :web,     '2014.fmi.py-bg.net'
role :app,     '2014.fmi.py-bg.net'
role :db,      '2014.fmi.py-bg.net', primary: true
