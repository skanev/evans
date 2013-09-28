namespace :dev do
  desc 'Fetch the production database'
  task :fetch do
    status = system 'cap sync:db -q > /dev/null'
    unless status
      puts 'Fetching the production database failed'
      exit 1
    end
    Rake::Task['dev:scramble_passwords'].invoke
  end

  task scramble_passwords: :environment do
    password = '123123'
    digest   = BCrypt::Password.create("#{password}#{Devise.pepper}", cost: Devise.stretches).to_s
    User.update_all encrypted_password: digest
    puts "All users' passwords are reset to: #{password}"
  end
end
