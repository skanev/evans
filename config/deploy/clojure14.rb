set :deploy_to, '/data/rails/clojure-2014'
set :database_name, 'clojure_2014'

role :web,     'fmi.clojure.bg'
role :app,     'fmi.clojure.bg'
role :db,      'fmi.clojure.bg', primary: true
role :sidekiq, 'fmi.clojure.bg'
