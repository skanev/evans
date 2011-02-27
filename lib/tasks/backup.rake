desc "Generates an SQL dump of the production database in the destination path provided as an argument."
task :backup, :destination, :needs => :environment do |t, args|
  conf = ActiveRecord::Base.connection.instance_variable_get :@config
  cmd  = "PGPASSWORD=#{conf[:password]} pg_dump -U #{conf[:username]} --inserts #{conf[:database]} -p #{conf[:port]} -h #{conf[:host]} > #{args.destination}"

  puts "Backing up '#{conf[:database]}' into: #{args.destination}"
  if system(cmd)
    puts "Dekimashita! (Ready! :)"
  else
    puts "Backup failed!\nCommand exit status: #{$?}\nCommand was: #{cmd}"
  end
end
