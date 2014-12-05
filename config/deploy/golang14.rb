set :deploy_to, '/data/rails/golang-2014'
set :database_name, 'golang_2014'

role :web,       '2014.fmi.golang.bg'
role :app,       '2014.fmi.golang.bg'
role :db,        '2014.fmi.golang.bg', primary: true
role :sidekiq,   '2014.fmi.golang.bg'
