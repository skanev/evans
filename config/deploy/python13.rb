set :deploy_to, '/data/rails/pyfmi-2013'
set :database_name, 'pyfmi_2013'

role :web,     '2013.fmi.py-bg.net'
role :app,     '2013.fmi.py-bg.net'
role :db,      '2013.fmi.py-bg.net', primary: true
