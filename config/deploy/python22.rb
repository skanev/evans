set :deploy_to, '/data/rails/pyfmi-2022'
set :database_name, 'pyfmi_2022'

role :web,     '2022.fmi.py-bg.net'
role :app,     '2022.fmi.py-bg.net'
role :db,      '2022.fmi.py-bg.net', primary: true
role :sidekiq, '2022.fmi.py-bg.net'
