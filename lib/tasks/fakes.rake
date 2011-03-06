desc "Generates fake data"
task :fake => :environment do
  Faker::Config.locale = 'en'
  require 'lib/fakes/factories.rb'

  20.times { Factory(:fake_user) }
  5.times { Factory(:fake_admin) }
  40.times { Factory(:fake_topic) }
  2000.times { Factory(:fake_reply) }
  20.times { Factory(:fake_announcement) }
  Factory(:fake_admin, :email => 'admin@example.org', :password => 'test', :password_confirmation => 'test')

  puts "Log in with:"
  puts "  user: admin@example.org"
  puts "  pass: test"
end
