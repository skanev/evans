set :deploy_to, '/data/rails/pyfmi-2012'
set :database_name, 'pyfmi_2012'

role :web,     '2012.fmi.py-bg.net'
role :app,     '2012.fmi.py-bg.net'
role :db,      '2012.fmi.py-bg.net', primary: true
