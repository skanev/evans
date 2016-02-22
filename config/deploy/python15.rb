set :deploy_to, '/data/rails/pyfmi-2015'
set :database_name, 'pyfmi_2015'

role :web,     '2015.fmi.py-bg.net'
role :app,     '2015.fmi.py-bg.net'
role :db,      '2015.fmi.py-bg.net', primary: true
