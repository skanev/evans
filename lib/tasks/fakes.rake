desc "Generates fake data"
task :fake => :environment do
  require 'lib/fakes/factories'

  [Solution, Task, Announcement, Reply, Topic, User].each do |model|
    model.destroy_all
  end

  20.times { Factory(:fake_user) }
  5.times { Factory(:fake_admin) }
  40.times { Factory(:fake_topic) }
  2000.times { Factory(:fake_reply) }
  20.times { Factory(:fake_announcement) }

  3.times { Factory(:fake_closed_task) }
  30.times { Factory(:fake_checked_solution) }

  1.times { Factory(:fake_open_task) }
  10.times { Factory(:fake_non_checked_solution) }

  Factory(:fake_admin, :email => 'admin@example.org', :password => 'test', :password_confirmation => 'test')
  puts "Log in with:"
  puts "  user: admin@example.org"
  puts "  pass: test"
end
