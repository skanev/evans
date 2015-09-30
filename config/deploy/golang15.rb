set :deploy_to, '/data/rails/golang-2015'
set :database_name, 'golang_2015'

role :web,     '2015.fmi.golang.bg'
role :app,     '2015.fmi.golang.bg'
role :db,      '2015.fmi.golang.bg', primary: true
role :sidekiq, '2015.fmi.golang.bg'
