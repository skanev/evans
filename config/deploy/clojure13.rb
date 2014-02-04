set :deploy_to,   '/data/rails/clojure-2013'
role :web,     'fmi.clojure.bg'
role :app,     'fmi.clojure.bg'
role :db,      'fmi.clojure.bg', :primary => true

set :database_name, 'clojure_2013'
