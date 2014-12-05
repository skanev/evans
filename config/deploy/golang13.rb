set :deploy_to, '/data/rails/golang-2013'
set :database_name, 'golang_2013'

role :web,       '2013.fmi.golang.bg'
role :app,       '2013.fmi.golang.bg'
role :db,        '2013.fmi.golang.bg', primary: true
