set :deploy_to, '/data/rails/ml-2017'
set :database_name, 'ml_2017'

role :web,     '2017.fmi.machine-learning.bg'
role :app,     '2017.fmi.machine-learning.bg'
role :db,      '2017.fmi.machine-learning.bg', primary: true
role :sidekiq, '2017.fmi.machine-learning.bg'
