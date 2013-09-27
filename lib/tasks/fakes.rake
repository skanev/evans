desc 'Generates fake data for development purposes'
task fake: :environment do
  require 'fakes/factories'

  [QuizResult, Quiz, Voucher, Comment, Revision, Solution, Task, Announcement, Reply, Topic, User].each do |model|
    model.delete_all
  end

  20.times  { FactoryGirl.create(:fake_user) }
  5.times   { FactoryGirl.create(:fake_admin) }
  20.times  { FactoryGirl.create(:fake_topic) }
  300.times { FactoryGirl.create(:fake_reply) }
  20.times  { FactoryGirl.create(:fake_announcement) }

  3.times   { FactoryGirl.create(:fake_closed_task) }
  30.times  { FactoryGirl.create(:fake_checked_solution) }

  1.times   { FactoryGirl.create(:fake_open_task) }
  10.times  { FactoryGirl.create(:fake_non_checked_solution) }

  1.times   { FactoryGirl.create(:fake_quiz) }
  15.times  { FactoryGirl.create(:fake_quiz_result) }

  FactoryGirl.create(:fake_admin, email: 'admin@example.org', password: 'test', password_confirmation: 'test')
  puts 'Log in with:'
  puts '  user: admin@example.org'
  puts '  pass: test'
end
